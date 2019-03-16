extends Sprite

var SCALE_FACTOR = Vector2(1.1, 1.1)
var MAX_SCALE = 3.5
var POS = Vector2(0,0)

func set_pos(pos):
	POS = pos

func _process(delta):
	self.transform = self.transform.scaled(SCALE_FACTOR)
	self.global_position = POS
	if self.transform.get_scale().x > MAX_SCALE:
		queue_free()
	pass
