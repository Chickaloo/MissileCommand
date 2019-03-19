extends Node2D

var _PLAYER = preload("res://objects/player/classic/Player.tscn")
var _ENEMY = preload("res://objects/enemy/classic/EnemyClassic.tscn")
var _CITY_LIVE = preload("res://objects/city/classic/CityLiveClassic.tscn")
var _CITY_DEAD = preload("res://objects/city/classic/CityDeadClassic.tscn")
var _LABEL = preload("res://scenes/classic/Text.tscn")
var level_label
const _CITY_LOCATIONS = [1,2,3,5,6,7]
var _CITY_DESTINATIONS = []
var _CITY_STATUS = [1,1,1,1,1,1]
var _X = 0
var _Y = 0
var print_loss = 0
var level_changing = 0
var level_changing_timer = 0
var enemy_spawn_rate = 120
var timer = 0
var enemies_spawned = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	globals.life = 6
	globals.score = 0
	globals.level = 0
	
	var label = _LABEL.instance()
	for c in label.get_children():
		if c is Label:
			level_label = c
	add_child(label)
	label.global_position = Vector2(_X/2, _Y/2)
	
	level_up()
	_X = get_viewport().size.x
	_Y = get_viewport().size.y
	# Draw Player
	var player = _PLAYER.instance()
	player.set_name("player")
	add_child(player)
	player.global_position = Vector2(_X/2, _Y-64)
	
	# Draw Cities
	var cityid = 0
	for i in _CITY_LOCATIONS:
		var city = _CITY_LIVE.instance()
		add_child(city)
		var loc = Vector2(_X*i/8, _Y-32)
		city.global_position = loc
		print(city.global_position)
		_CITY_DESTINATIONS.push_back(loc)
		city.set_name(str(cityid))
		_CITY_STATUS[cityid] = cityid
		cityid = cityid + 1
	
	pass # Replace with function body.

func level_up():
	globals.level = globals.level + 1
	globals.shots = globals.shots + globals.level * 15
	globals.enemies = globals.level * 6
	enemies_spawned = globals.enemies
	level_changing = 1
	level_changing_timer = 150
	enemy_spawn_rate = enemy_spawn_rate-10
	
	level_label.set_text("Level: " + str(globals.level))

func _process(delta):
	if level_changing == 1:
		level_changing_timer -= 1
		if level_changing_timer == 0:
			level_changing = 0
			level_label.set_text("")
	elif globals.life > 0:
		if globals.enemies > 0:
			if enemies_spawned > 0:
				if timer%enemy_spawn_rate == 0:
					var enemy = _ENEMY.instance()
					add_child(enemy)
					enemy.global_position = Vector2( randi()%int(get_viewport().size.x), -32 )
					enemy.set_variables(_CITY_DESTINATIONS[randi()%_CITY_DESTINATIONS.size()])
					enemies_spawned -= 1
				timer = timer + 1
		else:
			level_up()
	elif print_loss == 0:
		print_loss = 1
		level_label.set_text("GAME OVER!\nScore: " + str(globals.score))
		
		var t = Timer.new()
		t.set_wait_time(3)
		t.set_one_shot(true)
		self.add_child(t)
		t.start()
		yield(t, "timeout")
		t.queue_free()
		get_tree().change_scene("res://objects/menu/MainMenu.tscn")

	pass