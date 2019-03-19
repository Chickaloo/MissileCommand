extends Node

var mode = 0 # 0 = Classic, 1 = Upgraded
var score = 0
var shots = 999
var kills = 0
var life = 0
var enemies = 0
var level = 0
var VIEWPORT

# MAX_DISTANCE is the diagonal length of the viewport. Bullets cannot travel more than this distance
# and remain onscreen. Therefore, use this constant to despawn projectiles that can go offscreen.
var MAX_DISTANCE 

func _ready():
	VIEWPORT = get_viewport()
	MAX_DISTANCE = Vector2(0,0).distance_to(Vector2(VIEWPORT.size.x, VIEWPORT.size.y))

class Hittable extends Sprite:
	# Movement Stats
	var radius
	var origin
	var destination
	var direction
	var speed
	
	# Combat Stats
	var hitpoints
	var armor
	
	# State can be -1 (dead/despawning), 0 (idle), or 1 (alive)
	var state
	
	# Parent will refer to the Game World. Used to save time.
	var parent
	
	# Init is called when .new() is used. This is primarily for instantiation.
	# dest and spd are defaulted to 0 for immobile objects.
	# hp and armor are defaulted to 1.
	func _init(rad, pos, dest = Vector2(0,0), spd = 0, hp = 1, arm = 1):
		radius = rad
		origin = pos
		self.global_position = origin
		destination = dest
		direction = (destination-origin)/origin.distance_to(destination)
		speed = spd
		
		hitpoints = hp
		armor = arm
		
		state = 1
		
	# _ready() is called when the instance comes into existence. Use to 
	# set appearance of the object.
	func _ready():
		parent = get_parent()
		set_process(true)

	func _process(delta):
		if self.state == -1:
			print("dead")
			parent.enemies.erase(self)
			set_process(false)
			queue_free()
			return
			
	# damage accepts the incoming damage from a bullet.
	func damage(dmg):
		hitpoints -= dmg
		if hitpoints <= 0:
			state = -1
		print("%s damage taken! hp left: " % str(dmg), str(hitpoints) )
			
class AbstractEnemy extends AbstractBullet:
	
	func _init(rad, pos, dest = Vector2(0,0), spd = 0, hp = 1, arm = 1, dam = 1, t = null).(rad, pos, dest, spd, hp, arm, dam, t):
		pass
		
	func _ready():
		self.set_texture(image.IMAGE_ENEMY_ASTEROID)
		#self.set_material(image.EFFECT_GLOW_DEFAULT)
	
	func _process(delta):
		if self.global_position.y > globals.VIEWPORT.size.y:
			self.state = -1
		
class BasicEnemy extends AbstractEnemy:	
	func _init(rad, pos, dest = Vector2(globals.VIEWPORT.size.x/2,globals.VIEWPORT.size.y), spd = 300, hp = 1, arm = 1, dam = 1, t = null).(rad, pos, dest, spd, hp, arm, dam, t):
		pass
		
	func _ready():
		self.set_texture(image.IMAGE_ENEMY_BASIC)
	
	func _process(delta):
		pass
		
class AsteroidEnemy extends AbstractEnemy:
	func _init(rad, pos, dest = Vector2(globals.VIEWPORT.size.x/2,globals.VIEWPORT.size.y), spd = 50+randi()%200, hp = 20, arm = 1, dam = 5, t = null).(rad, pos, dest, spd, hp, arm, dam, t):
		pass
		
	func _ready():
		self.set_texture(image.IMAGE_ENEMY_ASTEROID)
	
	func _process(delta):
		self.rotation = self.rotation + 1*delta
		
		# Add cosmetic particle effect here
	
		
# AbstractBullet is any projectile that does damage, including certain
# enemies.
class AbstractBullet extends Hittable:
	var damage
	var target
	var wr
	
	# Distance travelled is used to despawn bullets that have gone too far.
	var distance_travelled

	# Bullets additionally have a damage and a target to seek out. Note: 
	# this makes bullets purely single target.
	func _init(rad, pos, dest, spd, hp, arm, dam, t).(rad, pos, dest, spd, hp, arm):
		damage = dam
		target = t
		distance_travelled = 0
		if t != null:
			wr = weakref(t)
		self.z_index = -50
		
	func _ready():
		._ready()
		
	func _process(delta):
		if target != null:
			if !wr.get_ref():
				target = null
			
		move(delta)
		
	func move(delta):			
		# If there still is a target to collide against
		if target != null:
			# If bullet hits target, damage the target and remove self
			if globals.collision(self, target):
				target.damage(self.damage)
				set_process(false)
				queue_free()
				return
		
		# Move bullet
		var movement = speed * direction * delta
		self.distance_travelled += Vector2(0,0).distance_to(movement)
		self.global_position = self.global_position + movement
		
		# If bullet has *gone too far*, despawn it.
		if self.distance_travelled > globals.MAX_DISTANCE:
			state = -1
		
class LaserBullet extends AbstractBullet:
		
	func _init(rad, pos, dest, spd, hp, arm, dam, t).(rad, pos, dest, spd, hp, arm, dam, t):
		pass
		
	func _ready():
		self.set_texture(image.IMAGE_TURRET_LASER_BULLET)
		self.modulate = Color(0, 1, 0)
		self.material = image.EFFECT_GLOW_DEFAULT
		self.look_at(destination)
		
class Explosion extends Hittable:
	var max_scale
	var scale_factor
	var damage
	var target_list
	
	# Replace instances of Vector2(0,0) with constant null vector
	func _init(rad, pos, dmg, enemy_list).(rad, pos):
		max_scale = stats.PLAYER_BULLET_EXPLOSION_SIZE
		scale_factor = Vector2(1.1, 1.1)
		self.damage = dmg
		# hack to create a copy of enemy_list array
		target_list = [] + enemy_list
		
	func _ready():
		set_texture(image.IMAGE_TURRET_PLAYER_BULLET_DETONATING_EXPLOSION)
		set_material(image.EFFECT_GLOW_DEFAULT)
		
	func _process(delta):
		self.transform = self.transform.scaled(scale_factor)
		self.global_position = origin
		self.radius *= scale_factor.x

		# gets expensive!
		for target in target_list:
			if globals.collision(self, target):
				# Erase so we only damage each target once
				target_list.erase(target)
				target.damage(self.damage)
		
		if self.transform.get_scale().x > max_scale:
			self.state = -1
			
# Detonating Bullet is the bullet that 	
class DetonatingBullet extends AbstractBullet:
	
	var max_distance
	
	func _init(rad, pos, dest, spd, hp, arm, dam, t = null).(rad, pos, dest, spd, hp, arm, dam, t):
		max_distance = pos.distance_to(dest)
	
	func _ready():
		self.set_texture(image.IMAGE_TURRET_PLAYER_BULLET_DETONATING)
		._ready()
	
	func _process(delta):
		pass
			
	func move(delta):
		# Move bullet
		var movement = speed * direction * delta
		self.distance_travelled += Vector2(0,0).distance_to(movement)
		self.global_position = self.global_position + movement
		
		# If bullet reached its destination, spawn an explosion object.
		if self.distance_travelled > self.max_distance:
			set_process(false)
			queue_free()
			
		return
		
# Collision returns whether or not two hittable objects have collided
func collision(a, b):
	var wr = weakref(b)
	if wr.get_ref():
		if a.position.distance_to(b.position) < a.radius + b.radius:
			return true
		else:
			return false
	return false
		