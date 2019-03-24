extends Node2D

var PLAYER_TSCN = preload("res://objects/player/classic/Player.tscn")
var TURRET_LASER_TSCN = preload("res://scenes/upgraded/assets/objects/turret_laser/turret_laser.tscn")
var UPGRADE_TSCN = preload("res://Upgrade System.tscn")
var player
var refire_rate = 0
var respawn = 0
var enemies = []
var spawner
var info_text
var level_text
var paused = false
var shopping = false
var shopping_spawned = false
var print_level_text_timer = 3
var death_timer = 5

class Spawner extends Node:
	var parent
	
	var enemies_to_spawn = 0
	var asteroid_chance = 90
	var min_delay = 3
	var max_delay = 1
	var spawn = 0
	
	func _init():
		globals.level = 0
		globals.score = 0
		globals.shots = 0
		globals.money = 0
		globals.kills = 0
		globals.life = 20
		globals.enemies = 0
		
	func level_up():
		globals.level += 1
		globals.score += 1000 * (globals.level-1)
		globals.money += 1000 * (globals.level-1)
		globals.life = stats.PLAYER_MAX_HP
		
			
		enemies_to_spawn = 5 + 8*(globals.level)
		var level_time = 10 + 2 * globals.level
		max_delay = level_time/float(enemies_to_spawn)
		asteroid_chance = 95 - 1*globals.level
		
		globals.shots = globals.shots + 29990*globals.level
		
		# Basic Enemy Data
		stats.ENEMY_BASIC_DAMAGE = 2 + globals.level
		stats.ENEMY_BASIC_HP = int((.2*globals.level)*(.2*globals.level))
		stats.ENEMY_BASIC_MOVEMENT_SPEED = 160 * ((6*globals.level)/float((4*globals.level+20)))
		stats.ENEMY_BASIC_VALUE = 100 + 25 * globals.level
		
		# Zigzag Enemy Data
		stats.ENEMY_ZIGZAG_DAMAGE = 1 + globals.level
		stats.ENEMY_ZIGZAG_HP = 1 + .3 * globals.level
		stats.ENEMY_ZIGZAG_MOVEMENT_SPEED = 120 + 160 * ((globals.level)/float((globals.level+20)))
		stats.ENEMY_ZIGZAG_VALUE = stats.ENEMY_BASIC_VALUE * 2
		
		# Splitting Enemy Data
		stats.ENEMY_SPLITTER_HP = 2 + 2 * globals.level
		stats.ENEMY_SPLITTER_MOVEMENT_SPEED = 30
		stats.ENEMY_SPLITTER_VALUE = stats.ENEMY_BASIC_VALUE
		stats.ENEMY_SPLITTER_COUNT = 1 + int((.2*globals.level)*(.2*globals.level))
		stats.ENEMY_SPLITTER_DAMAGE = stats.ENEMY_BASIC_DAMAGE * stats.ENEMY_SPLITTER_COUNT
		stats.ENEMY_SPLITTER_TIMER = 5
		
		# ASTEROID Enemy Data
		stats.ENEMY_ASTEROID_DAMAGE = 5 + globals.level
		stats.ENEMY_ASTEROID_HP = 2 + 8 * globals.level
		stats.ENEMY_ASTEROID_MOVEMENT_SPEED = 25 + 30 * ((5*globals.level)/float((4*globals.level+20)))
		stats.ENEMY_ASTEROID_VALUE = 250 + 50 * globals.level + stats.ENEMY_ASTEROID_HP * 10

		set_process(true)
		
	func _ready():
		parent = get_parent()
		
	func _process(delta):
		if parent.enemies.size() == 0 and self.enemies_to_spawn == 0:
			parent.print_level_text_timer = 3
			if globals.level != 0:
				parent.shopping = true
				globals.shopping = true
			set_process(false)
		elif enemies_to_spawn > 0:
			spawn -= delta
			if spawn < 0:
				var enemy
				var type = randi()%9
				if type == 0:
					enemy = globals.ZigzagEnemy.new(Vector2(randi()%int(globals.VIEWPORT.size.x),-10), Vector2(randi()%int(globals.VIEWPORT.size.x), globals.VIEWPORT.size.y))
				elif type == 1:
					enemy = globals.SplittingEnemy.new(Vector2(randi()%int(globals.VIEWPORT.size.x),-10), Vector2(randi()%int(globals.VIEWPORT.size.x), globals.VIEWPORT.size.y))
				else:
					if randi()%100>asteroid_chance:
						enemy = globals.AsteroidEnemy.new(Vector2(randi()%int(globals.VIEWPORT.size.x),-10), Vector2(randi()%int(globals.VIEWPORT.size.x), globals.VIEWPORT.size.y))
					else:
						enemy = globals.BasicEnemy.new(Vector2(randi()%int(globals.VIEWPORT.size.x),-10), Vector2(randi()%int(globals.VIEWPORT.size.x), globals.VIEWPORT.size.y))
				parent.add_child(enemy)
				parent.enemies.append(enemy)
				enemies_to_spawn -= 1
				spawn = max_delay
				
	func interim():
		return parent.enemies.size() == 0 and self.enemies_to_spawn == 0

func spawn_turret_laser():
	var turret = TURRET_LASER_TSCN.instance()
	add_child(turret)
	turret.global_position = Vector2(randi()%int(globals.VIEWPORT.size.x), globals.VIEWPORT.size.y-58)
	

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_ESCAPE:
			if paused:
				print("unpausing")
				level_text.set_text("")
				for c in get_children():
					c.set_process(true)
			else:
				print("pausing")
				level_text.set_text(" - P A U S E D - ")
				for c in get_children():
					c.set_process(false)
			paused = !paused
	globals.paused = paused

# Called when the node enters the scene tree for the first time.
func _ready():
	# Spawn player in center
	var player = PLAYER_TSCN.instance()
	add_child(player)
	player.global_position = Vector2(globals.VIEWPORT.size.x/2, globals.VIEWPORT.size.y-60)
	
	# Draw floor
	var floor_tile
	var i = 0
	while i < globals.VIEWPORT.size.x+100:
		floor_tile = Sprite.new()
		floor_tile.set_texture(image.IMAGE_PLAY_SCENE_FOREGROUND_FLOOR_TILING)
		floor_tile.global_position = Vector2(i, globals.VIEWPORT.size.y-16)
		add_child(floor_tile)
		floor_tile.set_process(false)
		
		floor_tile = Sprite.new()
		floor_tile.set_texture(image.IMAGE_PLAY_SCENE_FOREGROUND_FLOOR_TILING)
		floor_tile.modulate = Color(.4, .4, .4)
		floor_tile.global_position = Vector2(i+30, globals.VIEWPORT.size.y-30)
		floor_tile.z_index = -55
		add_child(floor_tile)
		floor_tile.set_process(false)
		
		i+= 100
	
	# Draw bright trees
	var tree
	var c
	var z
	i = 0
	while i < globals.VIEWPORT.size.x:
		i += randi()%100
		c = .2 + .2*(randi()%5)
		z = -50 * (1-c)
		tree = Sprite.new()
		tree.set_texture(image.IMAGE_PLAY_SCENE_BACKGROUND_TREE)
		tree.modulate = Color(c, c, c)
		tree.global_position = Vector2(i, globals.VIEWPORT.size.y-52+(z/2))
		tree.scale = Vector2(1 - (2 * randi()%2), 1)
		tree.z_index = z
		add_child(tree)
		tree.set_process(false)
		
	# Draw shrubben
	i = 0
	while i < globals.VIEWPORT.size.x:
		i += randi()%50
		c = .2 + .2*(randi()%5)
		z = -50 * (1-c)
		tree = Sprite.new()
		tree.set_texture(image.IMAGE_PLAY_SCENE_BACKGROUND_BUSH)
		tree.modulate = Color(c, c, c)
		tree.global_position = Vector2(i, globals.VIEWPORT.size.y-22+(z/2))
		tree.scale = Vector2(.6, .6)
		tree.z_index = z
		add_child(tree)
		tree.set_process(false)
		
	# Draw houses
	i = 0
	while i < globals.VIEWPORT.size.x:
		i += randi()%400
		c = .2 + .2*(randi()%5)
		z = -60 * (1-c)
		tree = Sprite.new()
		tree.set_texture(image.IMAGE_PLAY_SCENE_BACKGROUND_HOUSE)
		tree.modulate = Color(c*(randi()%2), c*(randi()%2), c*(randi()%2))
		tree.global_position = Vector2(i, globals.VIEWPORT.size.y-42+(z/2))
		tree.scale = Vector2(.8, .8)
		tree.z_index = z
		add_child(tree)
		tree.set_process(false)
		
	# Draw clouds
	i = 0
	while i < 20:
		i += 1
		tree = globals.Cloud.new()
		add_child(tree)
		tree.global_position.x = randi()%int(globals.VIEWPORT.size.x)
		tree.global_position.y = globals.VIEWPORT.size.y - 160 + rand_range(0, 32)
		
	for c in get_children():
		if c.name == "LevelText":
			level_text = c
			print(c.name)
		if c.name == "InfoText":
			info_text = c
			print(c.name)

	spawner = Spawner.new()
	add_child(spawner)	
	
func _process(delta):

	# If we are dead
	if globals.life < 1:
		level_text.set_text("Game Over!\nScore: " + str(globals.score))
		if death_timer > 0:
			death_timer -= delta
		else:
			get_tree().change_scene("res://objects/menu/MainMenu.tscn")

	# If game is live
	elif !paused:
		# Update status text
		info_text.set_text("HP: " + str(globals.life) + "\nScore: " +  str(globals.score) + "\nMoney: " +  str(globals.money) + "\nEnemies Left: " + str(spawner.enemies_to_spawn))
		
		# If level is ended:
		if spawner.interim():
			if shopping:
				if !shopping_spawned:
					shopping_spawned = true
					add_child(UPGRADE_TSCN.instance())
			elif print_level_text_timer > 0:
				print_level_text_timer -= delta
				level_text.set_text("Level " + str(globals.level+1))
			else:
				print_level_text_timer = 3
				level_text.set_text("")
				spawner.level_up()
	elif shopping:
		pass

func _on_TextureButton_pressed():
	if paused:
		print("unpausing")
		level_text.set_text("")
		for c in get_children():
			c.set_process(true)
	else:
		print("pausing")
		level_text.set_text(" - P A U S E D - ")
		for c in get_children():
			c.set_process(false)
	paused = !paused
	globals.paused = paused