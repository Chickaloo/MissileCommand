extends Sprite

var BULLET_SPEED = 300
var VELOCITY = Vector2(0, -300)
var DEST = Vector2(0,0)

func set_velocity(newvel):
	VELOCITY = (newvel-global_position)/global_position.distance_to(newvel)*BULLET_SPEED
	DEST = newvel

func _process(delta):
    move(delta)
    removeWhenOffScreen()

func move(delta):
    global_position += VELOCITY * delta

func removeWhenOffScreen():
    if global_position.distance_to(DEST) < 10:
		var explosion = preload("res://Explosion.tscn").instance()
        queue_free()