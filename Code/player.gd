extends CharacterBody2D

var INPUT_VECTOR = Vector2(0, 0)
var move_speed: float = 150.0
var health: int = 6
var next_potion: potions
var dead: bool = false

enum potions {HEALING, FIRE, WATER, SPEED, LIGHTNING, POISON, VENOM, BOMB, DEATH, SHADOW, ICE}
@export var potions_names = {potions.HEALING: "Healing", potions.FIRE: "Fire", potions.WATER: "Water", 
potions.SPEED: "Speed", potions.LIGHTNING: "Lightning", potions.POISON: "Poison", potions.VENOM: "Venom",
potions.BOMB: "Bomb", potions.DEATH: "Death", potions.SHADOW: "Shadow", potions.ICE: "Ice"}

@export var Potion :PackedScene

@onready var PLAYER_SPRITE = $PlayerSprite
@onready var THROW_POSITION = $PlayerSprite/ThrowPosition

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

func die():
	get_tree().change_scene_to_file("res://Scenes/title_screen.tscn")
