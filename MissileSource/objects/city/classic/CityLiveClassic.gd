extends Area2D

var _CITY_DEAD = preload("res://objects/city/classic/CityDeadClassic.tscn")
var world

# Called when the node enters the scene tree for the first time.
func _ready():
	world = get_parent().get_parent()
	pass # Replace with function body.

func _process(delta):
	var collisions = self.get_overlapping_areas()

	if collisions.size() != 0:
		for collision in collisions:
			if collision.get_parent().get_name().find("explosion") == -1:
				globals.life = globals.life - 1
				var newcity = _CITY_DEAD.instance()
				world._CITY_STATUS.remove(int(self.get_parent().get_name()))
				world._CITY_DESTINATIONS.remove(world._CITY_DESTINATIONS.find(self.get_parent().global_position))
				print(world._CITY_DESTINATIONS)
				world.add_child(newcity)
				newcity.global_position = self.global_position
				get_parent().queue_free()
	
	pass
