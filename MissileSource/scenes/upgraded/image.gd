# image.gd holds the image information for the textures.
extends Node

var IMAGE_CITY_LIVE
var IMAGE_CITY_DEAD

var IMAGE_TURRET_LASER_BODY
#var IMAGE_TURRET_LASER_BODY_HIGHLIGHTS
var IMAGE_TURRET_LASER_BARREL
#var IMAGE_TURRET_LASER_BARREL_HIGHLIGHTS
var IMAGE_TURRET_LASER_BULLET
var IMAGE_TURRET_LASER_BULLET_IMPACT

var IMAGE_TURRET_PLAYER_BARREL
#var IMAGE_PLAYER_TURRET_BARREL_HIGHLIGHTS
var IMAGE_TURRET_PLAYER_BODY
#var IMAGE_PLAYER_TURRET_BODY_HIGHLIGHTS
var IMAGE_TURRET_PLAYER_BULLET_DETONATING
var IMAGE_TURRET_PLAYER_BULLET_DETONATING_EXPLOSION

var IMAGE_ENEMY_BASIC
var IMAGE_ENEMY_ASTEROID

var IMAGE_PLAY_SCENE_FOREGROUND_FLOOR_TILING
var IMAGE_PLAY_SCENE_BACKGROUND_TREE

var EFFECT_GLOW_DEFAULT

func _ready():
	IMAGE_CITY_DEAD = preload("res://objects/city/classic/citydead.png")
	IMAGE_CITY_LIVE = preload("res://objects/city/classic/citylive.png")
	
	IMAGE_TURRET_LASER_BARREL = preload("res://scenes/upgraded/assets/images/turret_laser_barrel.png")
	IMAGE_TURRET_LASER_BULLET = preload("res://scenes/upgraded/assets/images/turret_laser_bullet.png")
	IMAGE_TURRET_LASER_BULLET_IMPACT = preload("res://scenes/upgraded/assets/images/turret_laser_bullet_impact.png")
	IMAGE_TURRET_PLAYER_BARREL = preload("res://scenes/upgraded/assets/images/turret_player_barrel.png")
	IMAGE_TURRET_PLAYER_BODY = preload("res://scenes/upgraded/assets/images/turret_player_body.png")
	IMAGE_TURRET_PLAYER_BULLET_DETONATING = preload("res://scenes/upgraded/assets/images/turret_player_bullet_detonating.png")
	IMAGE_TURRET_PLAYER_BULLET_DETONATING_EXPLOSION = preload("res://scenes/upgraded/assets/images/turret_player_bullet_detonating_explosion.png")

	# Temporary
	IMAGE_ENEMY_BASIC = preload("res://objects/enemy/classic/enemy.png")
	
	IMAGE_ENEMY_ASTEROID = preload("res://scenes/upgraded/assets/images/enemy_asteroid.png")
	
	IMAGE_PLAY_SCENE_FOREGROUND_FLOOR_TILING = preload("res://scenes/upgraded/assets/images/play_scene_foreground_floor_tiling.png")
	IMAGE_PLAY_SCENE_BACKGROUND_TREE = preload("res://scenes/upgraded/assets/images/play_scene_background_tree.png")

	EFFECT_GLOW_DEFAULT = CanvasItemMaterial.new()
	EFFECT_GLOW_DEFAULT.blend_mode = 1