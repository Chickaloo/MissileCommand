extends Node2D

# Variables that control the upgradeable values of the turret.
var damage
var bullet_speed
var burst_size
var refire_rate
var spread

# Variables that control the burstfire mode of the turret.
var bursting
var burst_cd
var enemy
var enemy_speed
var enemy_direction
var enemy_burst_loc
var enemy_ref
var target_cooldown

# Barrel node for controlling the motion of the barrel
var barrel

# For easy spawning of projectiles
var parent

func _init():
	damage = stats.TURRET_LASER_BULLET_DAMAGE
	bullet_speed = stats.TURRET_LASER_BULLET_SPEED
	burst_size = stats.TURRET_LASER_BURST_SIZE
	refire_rate = stats.TURRET_LASER_COOLDOWN
	spread = stats.TURRET_LASER_INACCURACY
	
	# that is to say, are we shooting a burst at an enemy?
	bursting = false
	burst_cd = .1
	enemy = null
	enemy_speed = null
	enemy_direction = null
	enemy_burst_loc = null
	enemy_ref = null
	target_cooldown = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	damage = 1
	bullet_speed = stats.TURRET_LASER_BULLET_SPEED
	burst_size = stats.TURRET_LASER_BURST_SIZE
	refire_rate = .1
	spread = 5
	
	# that is to say, are we shooting a burst at an enemy?
	bursting = false
	burst_cd = .05
	enemy = null
	enemy_speed = null
	enemy_direction = null
	enemy_burst_loc = null
	enemy_ref = null
	
	for n in get_children():
		if n.get_name() == "Barrel":
			barrel = n
			
	print(barrel)
	parent = get_parent()
	set_process(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if enemy == null:
		target_cooldown -= delta
		if target_cooldown < 0:
			target_cooldown = 1
			print("getting target")
			get_target()
	else:
		if enemy_burst_loc != null:
			barrel.look_at(enemy_burst_loc)
		shoot_at(delta)
		
func shoot_at(delta):
	# If the enemy exists
	if enemy_ref.get_ref():
		# If we can shoot
		var enemy_loc = enemy.global_position
		var d2e = barrel.global_position.distance_to(enemy_loc)
		var time_to_target = sqrt(d2e*d2e/(bullet_speed*bullet_speed + enemy_speed*enemy_speed))
		enemy_burst_loc = enemy_loc + enemy.direction * enemy.speed * time_to_target
		
		refire_rate -= delta
		if refire_rate < 0:
		
			# Calculate where to shoot at
			var target = Vector2(enemy_burst_loc.x + randi()%spread, enemy_burst_loc.y + randi()%spread)
			
			# I can just dynamically reference stats zzz then no need for upgrade()
			# Fix later
			var laser = globals.LaserBullet.new(
				stats.TURRET_LASER_BULLET_RADIUS, 
				barrel.global_position,		
				target,
				bullet_speed,
				1, #HP, Unused
				1, #Armor, Unused
				damage,
				enemy)
				
			parent.add_child(laser)
			
			refire_rate = .05
		# end if refire_rate 
			
	else:
		clean_target()
	pass
	
func get_target():
	if parent.enemies.size() > 0:
		enemy = parent.enemies[0]
		enemy_ref = weakref(enemy)
		if enemy_ref.get_ref():
			enemy_speed = enemy.speed
			enemy_direction = enemy.direction
			enemy_burst_loc = enemy.position
		else:
			enemy = null
			enemy_ref = null
		
func clean_target():
	print("cleaned")
	#clean up enemy references safely, and stop shooting.
	enemy = null
	enemy_speed = null
	enemy_direction = null
	enemy_burst_loc = null
	enemy_ref = null
	
	bursting = false
	refire_rate = burst_cd # Setting refire_rate here means we can pretend we switched targets instantly.
	burst_cd = .1

# Simply refreshes to whatever the new values are.
func upgrade():
	damage = stats.TURRET_LASER_BULLET_DAMAGE
	bullet_speed = stats.TURRET_LASER_BULLET_SPEED
	burst_size = stats.TURRET_LASER_BURST_SIZE
	refire_rate = stats.TURRET_LASER_COOLDOWN
	spread = stats.TURRET_LASER_INACCURACY