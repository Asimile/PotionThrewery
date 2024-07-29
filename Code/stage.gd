extends Node2D

@onready var ENEMY_SPAWN = $Player/EnemySpawnPath/PathFollow2D

var enemy = preload("res://Scenes/enemy.tscn")

func _ready():
	pass

func _on_enemy_spawn_timer_timeout():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	ENEMY_SPAWN.progress = rng.randi_range(0,1650)
	var enemy_instance = enemy.instantiate()
	
	enemy_instance.global_position = $Player/EnemySpawnPath/PathFollow2D/Marker2D.global_position
	add_child(enemy_instance)
