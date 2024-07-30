extends CharacterBody2D

var INPUT_VECTOR = Vector2(0, 0)
var move_speed: int = 150
var health: int = 6
var next_potion: potions
var dead: bool = false

enum potions {HEALING, DAMAGE, WATER, SPEED, DEATH, SHADOW, ICE}
@export var potions_names = {potions.HEALING: "Healing", potions.DAMAGE: "Damage", potions.WATER: "Water", 
potions.SPEED: "Speed", potions.DEATH: "Death", potions.SHADOW: "Shadow", potions.ICE: "Ice"}

@export var Potion :PackedScene

@onready var PLAYER_SPRITE = $PlayerSprite
@onready var THROW_POSITION = $PlayerSprite/ThrowPosition
@onready var SPEED_TIMER = $Timers/SpeedTimer
@onready var SHADOW_TIMER = $Timers/ShadowTimer
@onready var ICE_TIMER = $Timers/IceTimer
@onready var POTION_LABEL = $PotionLabel
@onready var HP_LABEL = $HPLabel
@onready var ICE_RECT = $IceRect
@onready var SHADOW_RECT = $PlayerSprite/ShadowRect

func _ready():
	pick_random_potion()

func _process(delta):
	if Input.is_action_just_pressed("throw"):
		throw_potion()
	if Input.is_action_just_pressed("drink"):
		drink_potion()

func _physics_process(delta):
	#get input direction
	INPUT_VECTOR.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	INPUT_VECTOR.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	
	
	velocity = INPUT_VECTOR.normalized() * move_speed
	
	#print(INPUT_VECTOR)
	
	move_and_slide()
	PLAYER_SPRITE.look_at(get_global_mouse_position())
	HP_LABEL.text = "HP: " + str(health)
	
	if health <= 0:
		die()
	
func hit_by_enemy(direction: Vector2):
	health -= 1
	print(health)
	velocity += direction * 1000
	move_and_slide()

# https://www.youtube.com/watch?v=ggt05fCiH7M&list=PLpwc3ughKbZexDyPexHN2MXLliKAovkpl&index=3
func throw_potion():
	var potion_instance = Potion.instantiate()
	get_parent().add_child(potion_instance)
	# Handles potion spawn position and direction
	potion_instance.global_position = THROW_POSITION.global_position
	var target = get_global_mouse_position()
	var direction_to_mouse = potion_instance.global_position.direction_to(target).normalized()
	potion_instance.set_direction(direction_to_mouse)
	# Assigns the newly made potion its type
	potion_instance.potion_type = next_potion
	# Picks the next random potion for the player
	pick_random_potion()
	
func drink_potion():
	var potion_instance = Potion.instantiate()
	add_child(potion_instance)
	potion_instance.global_position = THROW_POSITION.global_position
	potion_instance.collision_mask = (1 << 0)
	var target = get_global_mouse_position()
	var direction_to_mouse = potion_instance.global_position.direction_to(target).normalized()
	potion_instance.set_direction(direction_to_mouse)
	potion_instance.potion_type = next_potion
	# Picks a new random potion
	pick_random_potion()

func pick_random_potion():
	next_potion = potions.values().pick_random()
	#material.set_shader_parameter("OLD_COLOR", material.get_shader_parameter("NEW_COLOR"))
	#material.set_shader_parameter("NEW_COLOR", Color(1.0, 0.0, 0.0))
	print(potions_names[next_potion])
	POTION_LABEL.text = potions_names[next_potion] + " Potion"
	

func handle_potion_hit(potion_type):
	print("Player drank!")
	match potion_type:
		0:
			# Health potion
			health += 1
		1:
			# Damage potion
			health -= 1
		2:
			# Water potion
			pass
		3:
			# Speed potion
			move_speed += 30
			SPEED_TIMER.start()
		4:
			# Death potion
			die()
		5:
			# Shadow potion
			collision_layer = (0 << 0)
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
	get_tree().change_scene_to_file("res://Scenes/title_screen.tscn")


func _on_speed_timer_timeout():
	move_speed -= 30
	print("Player speed ended")

func _on_shadow_timer_timeout():
	collision_layer = (1 << 0)
	SHADOW_RECT.visible = false
	print("Player shadow ended")

func _on_ice_timer_timeout():
	move_speed = 150
	ICE_RECT.visible = false
	print("Player ice ended")
