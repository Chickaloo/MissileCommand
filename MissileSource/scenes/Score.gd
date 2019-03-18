extends Label

func _process(delta):
	self.text = "Level: " + str(globals.level) + "\nScore: " + str(globals.score) + "\nEnemies: " + str(globals.enemies) + "\nShots Left: " + str(globals.shots)
	pass
