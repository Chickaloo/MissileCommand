extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var _bullet = preload("res://Bullet.tscn")

func _ready(): 
	pass

func _input(event):
	
	if event is InputEventMouseMotion:
		self.look_at(event.position)
		
	if event is InputEventMouseButton:
		var bullet = _bullet.instance()
		bullet.global_position = global_position
		bullet.look_at(event.position)
		bullet.set_velocity(Vector2(event.position.x, event.position.y))
		get_parent().add_child(bullet)
	pass
	
	
	
func _process(delta):
	pass
