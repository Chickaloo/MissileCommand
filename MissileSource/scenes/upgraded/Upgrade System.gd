extends Control


func _on_ContinueButton_pressed():
	globals.shopping = false
	get_parent().shopping = false
	get_parent().shopping_spawned = false
	get_parent().remove_child(self)
	queue_free()


func _on_UpgradeMaxHP_pressed():
	if globals.money >= stats.PLAYER_MAX_HP_COST:
		globals.money = int(globals.money - stats.PLAYER_MAX_HP_COST)
		stats.PLAYER_MAX_HP_COST *= 1.2
		stats.PLAYER_MAX_HP_COST = int(stats.PLAYER_MAX_HP_COST)
		stats.PLAYER_MAX_HP += 10

func _on_UpgradePlayerDamage_pressed():
	if globals.money >= stats.PLAYER_BULLET_EXPLOSION_DAMAGE_COST:
		globals.money = int(globals.money - stats.PLAYER_BULLET_EXPLOSION_DAMAGE_COST)
		stats.PLAYER_BULLET_EXPLOSION_DAMAGE_COST *= 1.2
		stats.PLAYER_BULLET_EXPLOSION_DAMAGE_COST = int(stats.PLAYER_BULLET_EXPLOSION_DAMAGE_COST)
		stats.PLAYER_BULLET_EXPLOSION_DAMAGE += 2


func _on_UpgradePlayerExplosionRadius_pressed():
	if globals.money >= stats.PLAYER_BULLET_EXPLOSION_SIZE_COST:
		globals.money = int(globals.money - stats.PLAYER_BULLET_EXPLOSION_SIZE_COST)
		stats.PLAYER_BULLET_EXPLOSION_SIZE_COST *= 1.2
		stats.PLAYER_BULLET_EXPLOSION_SIZE_COST = int(stats.PLAYER_BULLET_EXPLOSION_SIZE_COST)
		stats.PLAYER_BULLET_EXPLOSION_SIZE += .2


func _on_UpgradeTurretCount_pressed():
	if globals.money >= stats.TURRET_LASER_COUNT_COST:
		globals.money = int(globals.money - stats.TURRET_LASER_COUNT_COST)
		stats.TURRET_LASER_COUNT_COST *= 1.1
		stats.TURRET_LASER_COUNT_COST = int(stats.TURRET_LASER_COUNT_COST)
		stats.TURRET_LASER_COUNT += 1
		get_parent().spawn_turret_laser()

func _on_UpgradeTurretDamage_pressed():
	if globals.money >= stats.TURRET_LASER_BULLET_DAMAGE_COST:
		globals.money = int(globals.money - stats.TURRET_LASER_BULLET_DAMAGE_COST)
		stats.TURRET_LASER_BULLET_DAMAGE_COST *= 1.2
		stats.TURRET_LASER_BULLET_DAMAGE_COST = int(stats.TURRET_LASER_BULLET_DAMAGE_COST)
		stats.TURRET_LASER_BULLET_DAMAGE += 1


func _on_UpgradeTurretBulletSpeed_pressed():
	if globals.money >= stats.TURRET_LASER_BULLET_SPEED_COST:
		globals.money = int(globals.money - stats.TURRET_LASER_BULLET_SPEED_COST)
		stats.TURRET_LASER_BULLET_SPEED_COST *= 1.2
		stats.TURRET_LASER_BULLET_SPEED_COST = int(stats.TURRET_LASER_BULLET_SPEED_COST)
		stats.TURRET_LASER_BULLET_SPEED += 20

func _on_UpgradeTurretFiringRate_pressed():
	if globals.money >= stats.TURRET_LASER_COOLDOWN_COST && stats.TURRET_LASER_COOLDOWN > .1:
		globals.money = int(globals.money - stats.TURRET_LASER_COOLDOWN_COST)
		stats.TURRET_LASER_COOLDOWN_COST *= 1.5
		stats.TURRET_LASER_COOLDOWN_COST = int(stats.TURRET_LASER_COOLDOWN_COST)
		stats.TURRET_LASER_COOLDOWN -= .1
