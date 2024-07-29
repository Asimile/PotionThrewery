extends CharacterBody2D

var INPUT_VECTOR = Vector2(0, 0)
var move_speed: float = 150.0
var health: int = 6
var next_potion: potions

enum potions {HEALING, FIRE, WATER, SPEED, LIGHTNING, POISON, VENOM, BOMB, DEATH, SHADOW, ICE}

@export var Potion :PackedScene

@onready var PLAYER_SPRITE = $PlayerSprite
@onready var THROW_POSITION = $PlayerSprite/ThrowPosition

func _ready():
	pick_random_potion()

func _process(delta):
	if Input.is_action_just_pressed("throw"):
		throw_potion()

func _physics_process(delta):
	#get input direction
	INPUT_VECTOR.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	INPUT_VECTOR.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	
	
	velocity = INPUT_VECTOR * move_speed
	
	#print(INPUT_VECTOR)
	
	move_and_slide()
	PLAYER_SPRITE.look_at(get_global_mouse_position())
	
func hit_by_enemy(direction: Vector2):
	health =- 1
	velocity += direction * 1000
	move_and_slide()

# https://www.youtube.com/watch?v=ggt05fCiH7M&list=PLpwc3ughKbZexDyPexHN2MXLliKAovkpl&index=3
func throw_potion():
	var potion_instance = Potion.instantiate()
	add_child(potion_instance)
	potion_instance.global_position = THROW_POSITION.global_position
	var target = get_global_mouse_position()
	var direction_to_mouse = potion_instance.global_position.direction_to(target).normalized()
	potion_instance.set_direction(direction_to_mouse)
	# Picks a new random potion
	pick_random_potion()

func pick_random_potion():
	next_potion = potions.values().pick_random()
	#material.set_shader_parameter("OLD_COLOR", material.get_shader_parameter("NEW_COLOR"))
	#material.set_shader_parameter("NEW_COLOR", Color(1.0, 0.0, 0.0))
