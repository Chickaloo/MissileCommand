extends Node

var score = 0
var shots = 0
var money = 0
var kills = 0
var life = 0
var enemies = 0
var level = 0
var VIEWPORT
var shopping = false
var paused = false

# MAX_DISTANCE is the diagonal length of the viewport. Bullets cannot travel more than this distance
# and remain onscreen. Therefore, use this constant to despawn projectiles that can go offscreen.
var MAX_DISTANCE 

func _ready():
	VIEWPORT = get_viewport()
	MAX_DISTANCE = Vector2(0,0).distance_to(Vector2(VIEWPORT.size.x, VIEWPORT.size.y))

class Hittable extends Sprite:
	# Movement Stats
	var radius = 4
	var origin
	var destination
	var direction
	var speed = 0
	
	# Combat Stats
	var hitpoints = 1
	var max_hitpoints = 1
	
	# State can be -1 (dead/despawning), 0 (idle), or 1 (alive)
	var state = 0
	
	# Parent will refer to the Game World. Used to save time.
	var parent
	
	# Init is called when .new() is used. This is primarily for instantiation.
	func _init(pos, dest):
		origin = pos
		self.global_position = origin
		destination = dest
		direction = (destination-origin)/origin.distance_to(destination)
	# _ready() is called when the instance comes into existence. Use to 
	# set appearance of the object.
	func _ready():
		parent = get_parent()
		set_process(true)

	func _process(delta):
			
		pre(delta)
		move(delta)
		post()
		
		if self.state < 0:
			get_parent().enemies.erase(self)
			set_process(false)
			free()
			
	# Using a seperate process(delta) here allows us to
	# Override the default process behavior
	func pre(delta):
		pass
		
	func move(delta):
		pass
		
	func post():
		pass
	
	# damage accepts the incoming damage from a bullet.
	func damage(dmg):
		hitpoints -= dmg
		if hitpoints <= 0:
			state = -1
			
class AbstractEnemy extends Hittable:
	var target
	var score
	var damage

	func _init(pos, dest, target = null).(pos, dest):
		self.target = target
		self.look_at(dest)

	func _process(delta):
		pass
			
	func pre(delta):
		if self.state < 0:
			globals.enemies -= 1
		if self.state == -1:
			var lba = DespawningAudio.new(image.SOUND_ENEMY_DEATH)
			parent.add_child(lba)
			var stext = ScoreText.new(score)
			parent.add_child(stext)
			stext.rect_global_position = self.global_position
			globals.score += score
			globals.money += score
			
	func move(delta):
		self.global_position += direction * speed * delta
			
	func post():
		if self.global_position.y > globals.VIEWPORT.size.y-32:
			var ea = globals.DespawningAudio.new(image.SOUND_ENEMY_CRASH)
			parent.add_child(ea)
			
			var htext = HealthText.new(self.damage)
			parent.add_child(htext)
			htext.rect_global_position = self.global_position
			var explosion = globals.EnemyExplosion.new(self.global_position)
			globals.life -= damage
			explosion.max_scale = 5
			parent.add_child(explosion)
			parent.enemies.erase(self)
			globals.enemies -= 1
			self.state = -2
		
class BasicEnemyTrail extends Sprite:
	var lifetime = 3
	var origin
	
	func _init(pos):
		self.set_texture(image.IMAGE_ENEMY_BASIC)
		self.origin = pos
		self.material = image.EFFECT_GLOW_DEFAULT
		self.transform = self.transform.scaled(Vector2(.3,.3))
		self.modulate = Color(5, 0, 0)
		self.z_index = -10
		
	func _ready():
		self.global_position = origin
		
	func _process(delta):
		lifetime -= delta
		self.transform = self.transform.scaled(Vector2(.99,.99))
		self.global_position = origin
		if lifetime < 0:
			queue_free()
			set_process(false)
		
class BasicEnemy extends AbstractEnemy:	

	var glow
	var trail_timer = .2

	func _init(pos, dest, target = null).(pos, dest, target):
		self.damage = stats.ENEMY_BASIC_DAMAGE
		self.hitpoints = stats.ENEMY_BASIC_HP
		self.max_hitpoints = stats.ENEMY_BASIC_HP
		self.speed = stats.ENEMY_BASIC_MOVEMENT_SPEED
		self.radius = stats.ENEMY_BASIC_RADIUS
		self.score = stats.ENEMY_BASIC_VALUE
		
	func _ready():
		self.set_texture(image.IMAGE_ENEMY_BASIC)
		glow = Sprite.new()
		glow.set_texture(image.IMAGE_TURRET_PLAYER_BULLET_DETONATING_EXPLOSION)
		glow.material = image.EFFECT_GLOW_DEFAULT
		glow.transform = glow.transform.scaled(Vector2(.2,.2))
		glow.modulate = Color(5, 0, 0)
		glow.z_index = -10
		add_child(glow)
		
	func move(delta):
		trail_timer -= delta
		if trail_timer < 0:
			trail_timer = .5
			parent.add_child(BasicEnemyTrail.new(self.global_position-(direction*14)))
		self.global_position += direction * speed * delta
		glow.global_position = self.global_position - (direction*14)

class ZigzagEnemy extends AbstractEnemy:	
	var change_direction_timer
	
	func _init(pos, dest, target = null).(pos, dest, target):
		self.damage = stats.ENEMY_ZIGZAG_DAMAGE
		self.hitpoints = stats.ENEMY_ZIGZAG_HP
		self.max_hitpoints = stats.ENEMY_ZIGZAG_HP
		self.speed = stats.ENEMY_ZIGZAG_MOVEMENT_SPEED
		self.radius = stats.ENEMY_ZIGZAG_RADIUS
		self.score = stats.ENEMY_ZIGZAG_VALUE
		
	func _ready():
		self.set_texture(image.IMAGE_ENEMY_ZIGZAG)		
		change_direction_timer = stats.ENEMY_ZIGZAG_TIMER
			
	func move(delta):
		change_direction_timer -= delta
		if change_direction_timer < 0 or self.global_position.x < 0 or self.global_position.x > globals.VIEWPORT.size.x:
			change_direction_timer = stats.ENEMY_ZIGZAG_TIMER*randf()
			direction *= Vector2(-1, 1)
			self.look_at(self.global_position+direction)
		self.global_position += direction * speed * delta
		
class SplittingEnemy extends AbstractEnemy:	
	var split_timer
	var split_count
	
	func _init(pos, dest, target = null).(pos, dest, target):
		self.damage = stats.ENEMY_SPLITTER_DAMAGE
		self.hitpoints = stats.ENEMY_SPLITTER_HP
		self.max_hitpoints = stats.ENEMY_SPLITTER_HP
		self.speed = stats.ENEMY_SPLITTER_MOVEMENT_SPEED
		self.radius = stats.ENEMY_SPLITTER_RADIUS
		self.score = stats.ENEMY_SPLITTER_VALUE
		self.split_timer = stats.ENEMY_SPLITTER_TIMER
		self.split_count = stats.ENEMY_SPLITTER_COUNT
		
	func _ready():
		self.set_texture(image.IMAGE_ENEMY_SPLITTER)
			
	func move(delta):
		if state == -1:
			for i in range(split_count):
				var enemy = BasicEnemy.new(self.global_position, Vector2(randi()%int(globals.VIEWPORT.size.x), globals.VIEWPORT.size.y))
				parent.add_child(enemy)
				parent.enemies.append(enemy)
				
		self.global_position += direction * speed * delta
		
class AsteroidEnemy extends AbstractEnemy:
	func _init(pos, dest, target = null).(pos, dest, target):
		self.damage = stats.ENEMY_ASTEROID_DAMAGE
		self.hitpoints = stats.ENEMY_ASTEROID_HP
		self.max_hitpoints = stats.ENEMY_ASTEROID_HP
		self.speed = stats.ENEMY_ASTEROID_MOVEMENT_SPEED
		self.radius = stats.ENEMY_ASTEROID_RADIUS
		self.score = stats.ENEMY_ASTEROID_VALUE
		
	func _ready():
		self.set_texture(image.IMAGE_ENEMY_ASTEROID)
	
	func _process(delta):
		self.rotation = self.rotation + 1 * delta
		
class AwesomeEnemy extends AbstractEnemy:	
	var change_direction_timer
	var split_timer
	var split_count
	
	func _init(pos, dest, target = null).(pos, dest, target):
		self.damage = stats.ENEMY_AWESOME_DAMAGE
		self.hitpoints = stats.ENEMY_ZIGZAG_HP
		self.max_hitpoints = stats.ENEMY_ZIGZAG_HP
		self.speed = stats.ENEMY_ZIGZAG_MOVEMENT_SPEED
		self.radius = stats.ENEMY_ZIGZAG_RADIUS
		self.score = stats.ENEMY_ZIGZAG_VALUE
		self.split_timer = stats.ENEMY_SPLITTER_TIMER
		self.split_count = stats.AWESOME_ENEMY_SPLITTER_COUNT
		
	func _ready():
		self.set_texture(image.IMAGE_ENEMY_AWESOME)		
		change_direction_timer = stats.ENEMY_ZIGZAG_TIMER
			
	func move(delta):
		change_direction_timer -= delta
		if change_direction_timer < 0 or self.global_position.x < 0 or self.global_position.x > globals.VIEWPORT.size.x:
			change_direction_timer = stats.ENEMY_ZIGZAG_TIMER*randf()
			direction *= Vector2(randf(), randf())
			self.look_at(self.global_position+direction)
		if state == -1:
			for i in range(split_count):
				var enemy = AwesomeEnemy.new(self.global_position, Vector2(randi()%int(globals.VIEWPORT.size.x), globals.VIEWPORT.size.y))
				parent.add_child(enemy)
				parent.enemies.append(enemy)
		self.global_position += direction * speed * delta
	
	func post():
		if self.global_position.y > globals.VIEWPORT.size.y-32:
			var ea = globals.DespawningAudio.new(image.SOUND_AWESOME_ENEMY_CRASH)
			parent.add_child(ea)
			
			parent.enemies.erase(self)
			globals.enemies -= 1
			self.state = -2
			
# AbstractBullet is any projectile that does damage, including certain
# enemies.
class AbstractBullet extends Hittable:
	var damage = 1
	var targets = []
	var wr
	var hit_sound = image.SOUND_TURRET_LASER_HIT
	var color
	
	# Distance travelled is used to despawn bullets that have gone too far.
	var distance_travelled

	# Bullets additionally have a damage and a target to seek out. Note: 
	# this makes bullets purely single target.
	func _init(pos, dest).(pos, dest):
		distance_travelled = 0
	
		self.z_index = -50
		
	func _ready():

		targets = [] + parent.enemies
		
	func move(delta):
		# If there still is a target to collide against
		if targets.size() != 0:
			collide()
		
		# Move bullet
		var movement = speed * direction * delta
		self.distance_travelled += Vector2(0,0).distance_to(movement)
		self.global_position = self.global_position + movement
		
		# If bullet has *gone too far*, despawn it.
		if self.distance_travelled > globals.MAX_DISTANCE:
			state = -1
			
	func collide():
		targets = [] + parent.enemies
		
		# If bullet hits target, damage the target and remove self
		for target in targets:
			var tref = weakref(target)
			if tref.get_ref():
				if globals.collision(self, target):
					var lba = DespawningAudio.new(hit_sound)
					parent.add_child(lba)
					var dtext = DamageText.new(self.damage, self.direction)
					parent.add_child(dtext)
					dtext.rect_position = target.global_position
					target.damage(self.damage)
					state = -1
					break
			else:
				targets.erase(target)

class LaserBullet extends AbstractBullet:
		
	func _init(pos, dest).(pos, dest):
		self.damage = stats.TURRET_LASER_BULLET_DAMAGE
		self.speed = stats.TURRET_LASER_BULLET_SPEED
		self.radius = stats.TURRET_LASER_BULLET_RADIUS
		self.color = stats.TURRET_LASER_BULLET_COLOR
		self.hit_sound = image.SOUND_TURRET_LASER_HIT
		
	func _ready():
		self.set_texture(image.IMAGE_TURRET_LASER_BULLET)
		self.modulate = self.color
		self.material = image.EFFECT_GLOW_DEFAULT
		self.look_at(destination)
		
	func post():
		if self.state == -1:			
			var lbi = LaserBulletImpact.new()
			parent.add_child(lbi)
			lbi.global_position = self.global_position
			lbi.look_at(self.global_position+direction)
		
class LaserBulletImpact extends Sprite:
	var timer = .03
	
	func _ready():
		set_texture(image.IMAGE_TURRET_LASER_BULLET_IMPACT)
		self.vframes = 1
		self.hframes = 10
		self.modulate = Color(0, 2, 0)
		self.material = image.EFFECT_GLOW_DEFAULT
		self.frame = 0
		self.z_index = 100
		self.scale = Vector2(2,2)
	
	func _process(delta):
		timer -= delta
		if timer < 0:
			frame += 1
			timer = .03
			
		if frame == 9:
			get_parent().remove_child(self)
			set_process(false)
			queue_free()
		
class DespawningAudio extends AudioStreamPlayer:
	
	var sound_timer
	
	func _init(sound):
		self.stream = load(sound)
		sound_timer = self.stream.get_length()
		
	func _ready():
		self.play()
		self.volume_db = -30
		
	func _process(delta):
		sound_timer -= delta
		if sound_timer < 0:
			queue_free()
		
class Cloud extends Sprite:
	var speed = 20
	var c
	
	func _ready():
		set_texture(image.IMAGE_PLAY_SCENE_BACKGROUND_CLOUD)
		
		c = randi()%5 * .2
		z_index = -1000 + c * 5
		modulate = Color(c,c,c)
		speed = speed + c * 20
		scale = Vector2(c, c)
		
	func _process(delta):
		self.global_position.x -= speed * delta
		if self.global_position.x < -64:
			self.global_position.x = globals.VIEWPORT.size.x + 64
			self.global_position.y = globals.VIEWPORT.size.y - 160 + (50*c) + rand_range(0, 32)
		
class Explosion extends Hittable:
	var max_scale
	var max_rad
	var scale_factor
	var damage
	var target_list
	
	# Replace instances of Vector2(0,0) with constant null vector
	func _init(rad, pos, dmg).(pos, Vector2(0,0)):
		max_scale = stats.PLAYER_BULLET_EXPLOSION_SIZE
		scale_factor = Vector2(1.1, 1.1)
		max_rad = rad * max_scale
		rad = rad * max_scale
		self.damage = dmg
		self.radius = rad
		
	func _ready():
		set_texture(image.IMAGE_TURRET_PLAYER_BULLET_DETONATING_EXPLOSION)
		self.modulate = stats.PLAYER_BULLET_COLOR
		set_material(image.EFFECT_GLOW_DEFAULT)
		# hack to create a copy of enemy_list array
		target_list = [] + parent.enemies
		
		# gets expensive!
		for target in target_list:
			if globals.collision(self, target):
				# Erase so we only damage each target once
				var dtext = DamageText.new(self.damage, self.direction)
				parent.add_child(dtext)
				dtext.rect_position = target.global_position
				target.damage(self.damage)
			
			
	func pre(delta):
		self.transform = self.transform.scaled(scale_factor)
		self.global_position = origin
		self.radius *= scale_factor.x

		if self.transform.get_scale().x > max_scale:
			queue_free()
		
class AnimExplosion extends Explosion:
	
	# Replace instances of Vector2(0,0) with constant null vector
	func _init(pos).(1, pos, 0):
		pass
		
	func pre(delta):
		self.transform = self.transform.scaled(scale_factor)
		self.global_position = origin
		self.radius *= (scale_factor.x)
		
		if radius > max_rad:
			queue_free()
			
class EnemyExplosion extends Explosion:
	
	# Replace instances of Vector2(0,0) with constant null vector
	func _init(pos).(1, pos, 0):
		self.transform = self.transform.scaled(Vector2(.3,.3))
		
	func _ready():
		set_texture(image.IMAGE_ENEMY_EXPLOSION)
		
		self.modulate = Color(5,3,0)
		self.material = image.EFFECT_GLOW_DEFAULT
		max_scale = 3
		max_rad = 16 * max_scale
		scale_factor = Vector2(1.5, 1.5)
		self.radius = 16 * .3
		
	func pre(delta):
		self.transform = self.transform.scaled(scale_factor)
		self.global_position = origin
		self.radius *= (scale_factor.x)
		
		if radius > max_rad:
			queue_free()
			
# Detonating Bullet is the bullet that the player shoots.
class DetonatingBullet extends AbstractBullet:
	
	var max_distance
	
	func _init(pos, dest).(pos, dest):
		max_distance = pos.distance_to(dest)
		speed = stats.PLAYER_BULLET_SPEED
	
	func _ready():
		self.set_texture(image.IMAGE_TURRET_PLAYER_BULLET_DETONATING)
		self.modulate = stats.PLAYER_BULLET_COLOR
		self.set_material(image.EFFECT_GLOW_DEFAULT)
		
	func move(delta):
		# Move bullet
		var movement = speed * direction * delta
		self.distance_travelled += Vector2(0,0).distance_to(movement)
		self.global_position = self.global_position + movement
		
		# If bullet reached its destination, spawn an explosion object.
		if self.distance_travelled > self.max_distance:
			var ea = globals.DespawningAudio.new(image.SOUND_EXPLOSION)
			parent.add_child(ea)
			
			var explosion = globals.Explosion.new(32, self.global_position, stats.PLAYER_BULLET_EXPLOSION_DAMAGE)
			parent.add_child(explosion)
			set_process(false)
			queue_free()
		
class LiveCity extends Hittable:
	func _init(rad, pos).(rad, pos):
		pass
	
	func _ready():
		self.radius = 32
		set_texture(image.IMAGE_CITY_LIVE)
		
	func pre(delta):
		if state == -1:
			set_texture(image.IMAGE_CITY_DEAD)
			get_parent()._CITIES.erase(self)
			globals.life -= 1
			set_process(false)
		
class DamageText extends Label:
	
	var speed = 100 + randi()%50
	var decel = 100
	var lifetime = speed/decel
	var direction
	
	func _init(damage, dir = Vector2(0,0)):
		set_text(str(damage))
		direction = dir + Vector2(randf(), randf())
	
	func _process(delta):
		if speed > 0:
			speed -= (decel*delta)
		lifetime -= delta
		
		self.rect_position = self.rect_position + direction * speed * delta
		
		if lifetime < 0:
			queue_free()
			set_process(false)
	
class ScoreText extends Label:
	
	var speed = 100
	var decel = 100
	var lifetime = speed/decel
	var direction = Vector2(0, 1)
	
	func _init(score):
		set_text("+" + str(score) + "g")
		modulate = Color(1, 1, 0)
		
	func _process(delta):
		if speed > 0:
			speed -= (decel*delta)
		lifetime -= delta
		
		self.rect_position = self.rect_position + direction * speed * delta
		
		if lifetime < 0:
			queue_free()
			set_process(false)
	
class HealthText extends Label:
	
	var speed = 100
	var decel = 100
	var lifetime = speed/decel
	var direction = Vector2(0, -1)
	
	func _init(damage):
		set_text("-" + str(damage) + " hp")
		modulate = Color(1, 0, 0)
		
	func _process(delta):
		if speed > 0:
			speed -= (decel*delta)
		lifetime -= delta
		
		self.rect_position = self.rect_position + direction * speed * delta
		
		if lifetime < 0:
			queue_free()
			set_process(false)
	
		
# Collision returns whether or not two hittable objects have collided
func collision(a, b):
	var wr = weakref(b)
	if wr.get_ref():
		if a.position.distance_to(b.position) < a.radius + b.radius:
			return true
		else:
			return false
	return false
		
