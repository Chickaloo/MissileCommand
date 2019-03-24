extends Sprite

var _BULLET = preload("res://objects/bullet/classic/BulletClassic.tscn")
var shots_fired = 0

func _input(event):
	if event is InputEventMouseMotion:
		self.look_at(event.position)
	if event is InputEventMouseButton:
		# Spawn one bullet on mouseup
		print("click")
		if event.is_pressed() and !globals.shopping and !globals.paused:	
			if globals.shots > 0:
				self.SpawnBullet(event.position)
				globals.shots -= 1

func SpawnBullet(destination):
	var ba = globals.DespawningAudio.new(image.SOUND_PLAYER_FIRING)
	get_parent().get_parent().add_child(ba)
	var bullet = globals.DetonatingBullet.new(self.global_position, destination)
	get_parent().get_parent().add_child(bullet)
	shots_fired = shots_fired + 1
	bullet.global_position = self.global_position