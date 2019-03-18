extends Sprite

# class member variables go here, for example:

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _process(delta):
	self.set_scale(.8,.8)
	if self.scale < .2:
		queue_free()
	pass
