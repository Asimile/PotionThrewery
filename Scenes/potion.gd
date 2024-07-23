extends Node2D

@onready var POTION_SPRITE = $PotionSprite

func _ready():
	pass

func _on_color_picker_button_color_changed(color):
	POTION_SPRITE.material.set_shader_parameter("NEW_COLOR", color)
	pass # Replace with function body.
