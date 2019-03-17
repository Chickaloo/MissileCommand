extends Area2D

var DIRECTION = Vector2(0,0)
var DESTINATION = Vector2(0,0)
var SPEED = 300

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_variables(dest):
	DESTINATION = dest
	var DIR = DESTINATION-self.global_position
	var dist = self.global_position.distance_to(DESTINATION)
	DIRECTION = Vector2( DIR.x/dist, DIR.y/dist )
	
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if self.global_position.distance_to(DESTINATION) < 5:
		#reduce city to rubble
		queue_free()
		
	var collisions = self.get_overlapping_areas()
	if collisions.size() != 0:
		queue_free()
		
	self.global_position = self.global_position + (DIRECTION * SPEED * delta)
	
	pass
