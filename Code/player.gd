extends CharacterBody2D

var INPUT_VECTOR = Vector2(0, 0)

var move_speed: float = 150.0

@export var Potion :PackedScene

@onready var PLAYER_SPRITE = $PlayerSprite
@onready var THROW_POSITION = $PlayerSprite/ThrowPosition

func _ready():
	pass

func _physics_process(delta):
	#get input direction
	INPUT_VECTOR.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	INPUT_VECTOR.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	
	
	velocity = INPUT_VECTOR * move_speed
	
	#print(INPUT_VECTOR)
	
	move_and_slide()
	PLAYER_SPRITE.look_at(get_global_mouse_position())
	
	
func _unhandled_input(event):
	if event.is_action_pressed("throw"):
		throw_potion()

func throw_potion():
	var potion_instance = Potion.instantiate()
	add_child(potion_instance)
	potion_instance.global_position = THROW_POSITION.global_position
	var target = get_global_mouse_position()
	var direction_to_mouse = potion_instance.global_position.direction_to(target).normalized()
	potion_instance.set_direction(direction_to_mouse)
