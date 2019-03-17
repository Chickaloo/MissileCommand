extends Node2D

var _PLAYER = preload("res://objects/player/classic/Player.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	
	# Draw Player
	var player = _PLAYER.instance()
	player.set_name("player")
	add_child(player)
	player.global_position = Vector2(get_viewport().size.x/2, get_viewport().size.y-64)
	
	# Draw 
	
	pass # Replace with function body.


#func _process(delta):
#	SPAWN ENEMIES @ RANDOM 

#	pass
