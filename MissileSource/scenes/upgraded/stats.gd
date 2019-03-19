extends Node

# Player Turret Data
var PLAYER_BULLET_EXPLOSION_DAMAGE = 5
var PLAYER_BULLET_EXPLOSION_SIZE = 2	# Maximum times larger than original explosion can be
var PLAYER_BULLET_SPEED = 200			# Pixels per second

# Laser Turret Data
var TURRET_LASER_BULLET_DAMAGE = 1
var TURRET_LASER_BULLET_RADIUS = 8
var TURRET_LASER_BULLET_SPEED = 500		# Pixels per second
var TURRET_LASER_BURST_SIZE = 1			# Bullets per attack
var TURRET_LASER_COOLDOWN = 3			# Seconds
var TURRET_LASER_INACCURACY = 50		# Max number of pixels target can be off (both x and y)

var TURRET_MISSILE_BULLET_DAMAGE = 2
var TURRET_MISSILE_EXPLOSION_DAMAGE = 4

# Basic Enemy Data
var ENEMY_BASIC_DAMAGE = 1
var ENEMY_BASIC_HP = 1
var ENEMY_BASIC_MOVEMENT_SPEED = 200

# Meteor Enemy Data
var ENEMY_METEOR_DAMAGE = 5
var ENEMY_METEOR_HP = 10
var ENEMY_METEOR_MOVEMENT_SPEED = 50

# Upgrade information
var UPGRADE_INCREMENT_PLAYER_BULLET_EXPLOSION_DAMAGE = 2
var UPGRADE_COST_PLAYER_BULLET_EXPLOSION_DAMAGE = 50
var UPGRADE_INCREMENT_PLAYER_BULLET_EXPLOSION_SIZE = .25
var UPGRADE_COST_PLAYER_BULLET_EXPLOSION_SIZE = 50
var UPGRADE_INCREMENT_PLAYER_BULLET_SPEED = 25
var UPGRADE_COST_PLAYER_BULLET_SPEED = 50