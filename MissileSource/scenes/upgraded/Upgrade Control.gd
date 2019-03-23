extends Node2D

var money_text
var level_text
var player_max_hp_text
var player_max_hp_cost_text
var player_damage_text
var player_damage_cost_text
var player_explosion_radius_text
var player_explosion_radius_cost_text
var turret_count_text
var turret_count_cost_text
var turret_damage_text
var turret_damage_cost_text
var turret_speed_text
var turret_speed_cost_text
var turret_rate_text
var turret_rate_cost_text

func _ready():
	for c in get_children():
		if c.name == "Money":
			money_text = c
		elif c.name == "Level":
			level_text = c
			level_text.set_text(str(globals.level))
		elif c.name == "CurrentMaxHP": 
			player_max_hp_text = c
		elif c.name == "MaxHPUpgradeCost": 
			player_max_hp_cost_text = c
		elif c.name == "CurrentPlayerDamage": 
			player_damage_text = c
		elif c.name == "PlayerDamageUpgradeCost": 
			player_damage_cost_text = c
		elif c.name == "PlayerExplosionRadius": 
			player_explosion_radius_text = c
		elif c.name == "PlayerExplosionRadiusUpgradeCost": 
			player_explosion_radius_cost_text = c
		elif c.name == "CurrentTurretCount": 
			turret_count_text = c
		elif c.name == "AdditionalTurretCost": 
			turret_count_cost_text = c
		elif c.name == "CurrentTurretDamage": 
			turret_damage_text = c
		elif c.name == "TurretDamageCost": 
			turret_damage_cost_text = c
		elif c.name == "CurrentTurretBulletSpeed": 
			turret_speed_text = c
		elif c.name == "TurretBulletSpeedCost": 
			turret_speed_cost_text = c
		elif c.name == "CurrentTurretFiringRate": 
			turret_rate_text = c
		elif c.name == "TurretFiringRateCost": 
			turret_rate_cost_text = c

func _process(delta):
	money_text.set_text(str(globals.money))
		
	player_max_hp_text.set_text(str(stats.PLAYER_MAX_HP))
	player_max_hp_cost_text.set_text(str(stats.PLAYER_MAX_HP_COST))
	player_damage_text.set_text(str(stats.PLAYER_BULLET_EXPLOSION_DAMAGE))
	player_damage_cost_text.set_text(str(stats.PLAYER_BULLET_EXPLOSION_DAMAGE_COST))
	player_explosion_radius_text.set_text(str(stats.PLAYER_BULLET_EXPLOSION_SIZE))
	player_explosion_radius_cost_text.set_text(str(stats.PLAYER_BULLET_EXPLOSION_SIZE_COST))
	turret_count_text.set_text(str(stats.TURRET_LASER_COUNT))
	turret_count_cost_text.set_text(str(stats.TURRET_LASER_COUNT_COST))
	turret_damage_text.set_text(str(stats.TURRET_LASER_BULLET_DAMAGE))
	turret_damage_cost_text.set_text(str(stats.TURRET_LASER_BULLET_DAMAGE_COST))
	turret_speed_text.set_text(str(stats.TURRET_LASER_BULLET_SPEED))
	turret_speed_cost_text.set_text(str(stats.TURRET_LASER_BULLET_SPEED_COST))
	turret_rate_text.set_text(str(stats.TURRET_LASER_COOLDOWN))
	turret_rate_cost_text.set_text(str(stats.TURRET_LASER_COOLDOWN_COST))

