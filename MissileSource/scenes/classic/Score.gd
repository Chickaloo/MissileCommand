extends Label

func _process(delta):
	self.text = "Level: " + str(globals.level) + "\nHealth: " + str(globals.life) + "\nScore: " + str(globals.score) + "\nEnemies: " + str(globals.enemies) + "\nShots Left: " + str(globals.shots)
