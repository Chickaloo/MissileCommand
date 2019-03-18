extends Node2D

var _PLAYER = preload("res://objects/player/classic/Player.tscn")
var _ENEMY = preload("res://objects/enemy/classic/EnemyClassic.tscn")
var timer = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	
	# Draw Player
	var player = _PLAYER.instance()
	player.set_name("player")
	add_child(player)
	player.global_position = Vector2(get_viewport().size.x/2, get_viewport().size.y-64)
	
	# Draw
	
	
	pass # Replace with function body.

func _process(delta):
	if timer%100 == 0:
		var enemy = _ENEMY.instance()
		enemy.global_position = Vector2( randi()%int(get_viewport().size.x), -32 )
		add_child(enemy)
		enemy.set_variables(Vector2(randi()%int(get_viewport().size.x), get_viewport().size.y))
		
	timer = timer + 1
	pass