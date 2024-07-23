extends CharacterBody2D

var INPUT_VECTOR = Vector2(0, 0)

@export var move_speed: float = 200.0

func _ready():
	pass

func _physics_process(delta):
	#get input direction
	INPUT_VECTOR.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	INPUT_VECTOR.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	
	
	velocity = INPUT_VECTOR * move_speed
	
	#print(INPUT_VECTOR)
	
	move_and_slide()
	look_at(get_global_mouse_position())
