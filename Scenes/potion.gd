extends Node2D

var potion_speed: float = 5.0

var direction: Vector2 = Vector2.ZERO

@onready var POTION_SPRITE = $PotionSprite

func _ready():
	pass

func _physics_process(delta: float):
	if direction != Vector2.ZERO:
		var velocity = direction * potion_speed
		
		global_position += velocity
		rotate(deg_to_rad(15.0))

func set_direction(direction: Vector2):
	self.direction = direction

func _on_color_picker_button_color_changed(color):
	POTION_SPRITE.material.set_shader_parameter("NEW_COLOR", color)
	pass # Replace with function body.
