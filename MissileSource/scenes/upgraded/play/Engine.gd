extends Node2D

var PLAYER_TSCN = preload("res://objects/player/classic/Player.tscn")
var TURRET_LASER_TSCN = preload("res://scenes/upgraded/assets/objects/turret_laser/turret_laser.tscn")
var player
var refire_rate = 0
var bursting = false
var burst_cd = .1
var burst_size = 3
var respawn = 0
var enemy = null
var enemy_burst_loc = null
var wr = null
var enemies = []
# Called when the node enters the scene tree for the first time.
func _ready():
	
	# Spawn player in center
	var player = PLAYER_TSCN.instance()
	add_child(player)
	player.global_position = Vector2(globals.VIEWPORT.size.x/2, globals.VIEWPORT.size.y-32)
	
	var turret = TURRET_LASER_TSCN.instance()
	add_child(turret)
	turret.global_position = Vector2(randi()%int(globals.VIEWPORT.size.x), globals.VIEWPORT.size.y-32)

func _process(delta):
		
	# Test Enemy Hit Code
	if enemy == null:
		respawn -= delta
		if respawn < 0:
			respawn = 3
			print(respawn)
			enemy = globals.AbstractEnemy.new(32, Vector2(randi()%int(globals.VIEWPORT.size.x),-10), Vector2(randi()%int(globals.VIEWPORT.size.x), globals.VIEWPORT.size.y), 200, randi()%30, 1, 1, null)
			wr = weakref(enemy)
			add_child(enemy)
			enemies.append(enemy)

	if bursting == true:
		if burst_size == 0:
			bursting = false
		else:
			burst_cd -= delta
			if burst_cd < 0:
				burst_cd = .1
				
				#fire
				var laser
				if wr.get_ref():
					laser = globals.LaserBullet.new(8, Vector2(globals.VIEWPORT.size.x/2, globals.VIEWPORT.size.y-32), Vector2(enemy_burst_loc.x+randi()%50,enemy_burst_loc.y+randi()%50), 800, 1, 1, 1, enemy)
				else:
					laser = globals.LaserBullet.new(8, Vector2(globals.VIEWPORT.size.x/2, globals.VIEWPORT.size.y-32), Vector2(enemy_burst_loc.x+randi()%50,enemy_burst_loc.y+randi()%50), 800, 1, 1, 1, null)						
				#add_child(laser)
			
				burst_size -= 1
	else:
		refire_rate -= delta
		if refire_rate < 0:
			if wr.get_ref():
				enemy_burst_loc = enemy.global_position
			else:
				enemy = null
			bursting = true
			refire_rate = 1
			burst_cd = 0
			burst_size = 3
			
	if !wr.get_ref():
		enemy = null