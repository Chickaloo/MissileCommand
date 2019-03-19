extends Control

var TURRET_LASER_TSCN = preload("res://scenes/upgraded/assets/objects/turret_laser/turret_laser.tscn")
var respawn = 0
var enemy = null
var wr = null
var enemies = []

func _ready():
	var turret = TURRET_LASER_TSCN.instance()
	add_child(turret)
	turret.global_position = Vector2(randi()%int(globals.VIEWPORT.size.x/2), globals.VIEWPORT.size.y-32)

func _process(delta):
	if enemies.size() == 0:
		respawn -= delta
		if respawn < 0:
			respawn = 1
			enemy = globals.AbstractEnemy.new(32, Vector2(randi()%int(globals.VIEWPORT.size.x),-10), Vector2(randi()%int(globals.VIEWPORT.size.x), globals.VIEWPORT.size.y), 200, randi()%30, 1, 1, null)
			add_child(enemy)
			wr = weakref(enemy)
			enemies.append(enemy)
			print(enemies)


func _on_Exit_pressed():
	get_tree().quit()

func _on_Classic_pressed():
	get_tree().change_scene("res://scenes/classic/World.tscn")

func _on_Upgrade_pressed():
	get_tree().change_scene("res://scenes/upgraded/play/Play.tscn")
