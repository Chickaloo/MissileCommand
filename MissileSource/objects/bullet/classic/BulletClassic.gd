extends Sprite

var DESTINATION = Vector2(0,0)
var DIRECTION = Vector2(0,0)
#var DAMAGE = 1
var SPEED = 750
var _EXPLOSION = preload("res://objects/explosion/classic/ExplosionClassic.tscn")

func set_destination(dest):
	DESTINATION = dest
	var DIR = DESTINATION-self.global_position
	var dist = self.global_position.distance_to(DESTINATION)
	DIRECTION = Vector2( DIR.x/dist, DIR.y/dist )
	
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if self.global_position.distance_to(DESTINATION) < 8:
		var explosion = _EXPLOSION.instance()
		get_parent().add_child(explosion)
		explosion.set_pos(self.global_position)
		explosion.set_name(self.name + "explosion")
		queue_free()
		
	self.global_position = self.global_position + (DIRECTION * SPEED * delta)
	
	pass
