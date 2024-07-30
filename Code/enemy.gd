extends CharacterBody2D

var move_speed: float = 40.0
var enemy_health: int = 2

@onready var ENEMY_SPRITE = $EnemySprite
@onready var SPEED_TIMER = $SpeedTimer
@onready var SHADOW_TIMER = $ShadowTimer
@onready var ICE_TIMER = $IceTimer
@onready var ICE_RECT = $IceRect
@onready var SHADOW_RECT = $EnemySprite/ShadowRect
@onready var ENEMY_HEALTH = $EnemyHealth

func _physics_process(delta):
	var player = get_parent().get_node("Player")
	
	ENEMY_SPRITE.look_at(player.global_position)
	
	velocity = ((player.global_position - global_position).normalized()) * move_speed
	
	move_and_slide()
	
	ENEMY_HEALTH.text = str(enemy_health)
	
	if enemy_health <= 0:
		die()

func handle_potion_hit(potion_type: int):
	print("Enemy hit!")
	match potion_type:
		0:
			# Health potion
			enemy_health += 1
		1:
			# Damage potion
			enemy_health -= 1
		2:
			# Water potion
			pass
		3:
			# Speed potion
			move_speed += 20
			SPEED_TIMER.start()
		4:
			# Death potion
			die()
		5:
			# Shadow potion
			collision_layer = (0 << 4)
			SHADOW_RECT.visible = true
			SHADOW_TIMER.start()
		6:
			# Ice potion
			move_speed = 0
			ICE_RECT.visible = true
			ICE_TIMER.start()
		_:
			pass
	

func die():
	queue_free()


func _on_enemy_hurtbox_body_entered(body):
	print("EnemyHurtbox triggered")
	var player = get_parent().get_node("Player")
	body.hit_by_enemy((player.global_position - global_position).normalized())


func _on_spawn_check_body_entered(body):
	print("AAAAAAAAAAAA")
	queue_free()


func _on_speed_timer_timeout():
	move_speed -= 20

func _on_shadow_timer_timeout():
	collision_layer = (1 << 4)
	SHADOW_RECT.visible = false

func _on_ice_timer_timeout():
	move_speed = 40
	ICE_RECT.visible = false
