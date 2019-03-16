extends Sprite

var _BULLET = preload("res://objects/bullet/classic/BulletClassic.tscn")
var shots_fired = 0

func _input(event):
	if event is InputEventMouseMotion:
		self.look_at(event.position)
	if event is InputEventMouseButton:
		# Spawn one bullet on mouseup
		if !event.is_pressed():
			self.SpawnBullet(event.position)
	pass
		
func SpawnBullet(destination):
	var bullet = _BULLET.instance()
	get_parent().add_child(bullet)
	bullet.global_position = self.global_position
	bullet.set_destination(destination)
	bullet.set_name("bullet" + str(++shots_fired))
	
	pass