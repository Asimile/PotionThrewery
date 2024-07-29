extends CharacterBody2D

var move_speed: float = 40.0
var enemy_health: int = 2

func _physics_process(delta):
	var player = get_parent().get_node("Player")
	
	look_at(player.global_position)
	
	velocity = ((player.global_position - global_position).normalized()) * move_speed
	
	move_and_slide()

func handle_hit():
	print("Enemy hit!")
	enemy_health -= 1
	if enemy_health <= 0:
		die()

func die():
	queue_free()


func _on_enemy_hurtbox_body_entered(body):
	print("EnemyHurtbox triggered")
	var player = get_parent().get_node("Player")
	body.hit_by_enemy((player.global_position - global_position).normalized())


func _on_spawn_check_body_entered(body):
	print("AAAAAAAAAAAA")
	queue_free()
