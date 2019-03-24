extends Control

var TURRET_LASER_TSCN = preload("res://scenes/upgraded/assets/objects/turret_laser/turret_laser.tscn")
var respawn = 0
var enemies = []

func _ready():
	var turret = TURRET_LASER_TSCN.instance()
	add_child(turret)
	turret.global_position = Vector2(randi()%int(globals.VIEWPORT.size.x/2), globals.VIEWPORT.size.y-48)
	
	stats.TURRET_LASER_BULLET_DAMAGE = 2
	stats.TURRET_LASER_BULLET_SPEED = 800
	stats.TURRET_LASER_COOLDOWN = .5
	
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
		
func _process(delta):
	respawn -= delta
	if respawn < 0:
		respawn = 3
		var enemy = globals.AsteroidEnemy.new(Vector2(randi()%int(globals.VIEWPORT.size.x),-10), Vector2(randi()%int(globals.VIEWPORT.size.x), globals.VIEWPORT.size.y))
		add_child(enemy)
		enemies.append(enemy)

func _on_Exit_pressed():
	get_tree().quit()

func _on_Classic_pressed():
	get_tree().change_scene("res://scenes/classic/World.tscn")

func _on_Upgrade_pressed():
	stats.reset()
	get_tree().change_scene("res://scenes/upgraded/play/Play.tscn")
