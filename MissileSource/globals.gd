extends Node

var mode = 0 # 0 = Classic, 1 = Upgraded
var score = 0
var shots = 0
var kills = 0
var life = 0
var enemies = 0
var level = 0

var IMAGE_DEFAULT_BULLET


func _ready():
	IMAGE_DEFAULT_BULLET = preload("res://objects/bullet/classic/bullet.png")

class Hittable extends Sprite:
	var radius
	var origin
	
	func _init(rad, pos):
		radius = rad
		origin = pos
		pass
		
	func _ready():
		pass
		
	func _process(delta):
		pass
		
class AbstractBullet extends Hittable:
	var damage
	var destination
	var speed
	var target
	
	func _init(rad, start, end, spd, dam, t).(rad, start):
		destination = end
		speed = spd
		damage = dam
		target = t
		
	func _ready():
		set_texture(globals.IMAGE_DEFAULT_BULLET)
		
	func _process(delta):
		if globals.collision(self, target):
			queue_free()
			
			
	
# Collision returns whether or not two hittable objects have collided
func collision(a, b):
	if a.position.distance_to(b.position) < a.radius + b.radius:
		return true
	else:
		return false
		