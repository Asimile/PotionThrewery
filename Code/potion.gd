extends Node2D

var potion_type
var potion_speed: float = 5.0
var direction: Vector2 = Vector2.ZERO

@onready var POTION_SPRITE = $PotionSprite
@onready var KILL_TIMER = $KillTimer

func _ready():
	KILL_TIMER.start()

func _physics_process(delta: float):
	if direction != Vector2.ZERO:
		var velocity = direction * potion_speed
		
		global_position += velocity
		rotate(deg_to_rad(15.0))

func set_direction(direction: Vector2):
	self.direction = direction

func _on_color_picker_button_color_changed(color):
	POTION_SPRITE.material.set_shader_parameter("NEW_COLOR", color)

func _on_kill_timer_timeout():
	print(potion_type)
	queue_free()

func _on_body_entered(body):
	if body.has_method("handle_potion_hit"):
		body.handle_potion_hit(potion_type)
		# I think for time purposes, I'm omitting any AOE things
		queue_free()
	else:
		print("Wall or player hit?")
		queue_free()
