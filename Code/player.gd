extends CharacterBody2D

var INPUT_VECTOR = Vector2(0, 0)
var move_speed: float = 150.0
var health: int = 6
var next_potion: potions
var dead: bool = false

enum potions {HEALING, DAMAGE, FIRE, WATER, SPEED, POISON, DEATH, SHADOW, ICE}
@export var potions_names = {potions.HEALING: "Healing", potions.FIRE: "Fire", potions.DAMAGE: "Damage",
potions.WATER: "Water", potions.SPEED: "Speed", potions.POISON: "Poison", potions.DEATH: "Death", 
potions.SHADOW: "Shadow", potions.ICE: "Ice"}

@export var Potion :PackedScene

@onready var PLAYER_SPRITE = $PlayerSprite
@onready var THROW_POSITION = $PlayerSprite/ThrowPosition
@onready var SPEED_TIMER = $SpeedTimer
@onready var SHADOW_TIMER = $ShadowTimer
@onready var ICE_TIMER = $IceTimer
@onready var POTION_LABEL = $PotionLabel

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
	
	
	velocity = INPUT_VECTOR * move_speed
	
	#print(INPUT_VECTOR)
	
	move_and_slide()
	PLAYER_SPRITE.look_at(get_global_mouse_position())
	
func hit_by_enemy(direction: Vector2):
	health -= 1
	print(health)
	velocity += direction * 1000
	move_and_slide()
	if health <= 0:
		if !dead:
			dead = true
			die()

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
	# Picks a new random potion
	pick_random_potion()

func pick_random_potion():
	next_potion = potions.values().pick_random()
	#material.set_shader_parameter("OLD_COLOR", material.get_shader_parameter("NEW_COLOR"))
	#material.set_shader_parameter("NEW_COLOR", Color(1.0, 0.0, 0.0))
	print(potions_names[next_potion])
	POTION_LABEL.text = potions_names[next_potion] + " Potion"
	

func handle_potion_hit(potion_type):
	print("Enemy hit!")
	match potion_type:
		0:
			# Health potion
			health += 1
		1:
			# Fire potion
			pass
		2:
			# Damage potion
			health -= 1
		3:
			# Water potion
			pass
		4:
			# Speed potion
			move_speed += 20
			SPEED_TIMER.start()
		5:
			# Poison potion
			pass
		6:
			# Death potion
			die()
		7:
			# Shadow potion
			collision_layer = (0 << 0)
			SHADOW_TIMER.start()
		8:
			# Ice potion
			move_speed = 0
			ICE_TIMER.start()
		_:
			pass

func die():
	get_tree().change_scene_to_file("res://Scenes/title_screen.tscn")


func _on_speed_timer_timeout():
	move_speed -= 20

func _on_shadow_timer_timeout():
	collision_layer = (1 << 0)


func _on_ice_timer_timeout():
	move_speed = 150
