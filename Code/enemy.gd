extends CharacterBody2D

var enemy_speed: float = 60.0
var enemy_health: int = 2

func _physics_process(delta):
	var player = get_parent().get_node("Player")
	
	look_at(player.global_position)
	
	velocity = ((player.global_position - global_position).normalized()) * enemy_speed
	
	move_and_slide()

func handle_hit():
	print("Enemy hit!")
	enemy_health -= 1
	if enemy_health <= 0:
		die()

func die():
	queue_free()
