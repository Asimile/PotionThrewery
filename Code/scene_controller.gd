extends Node

var NEXT_SCENE
@onready var ANIMATION_PLAYER = $AnimationPlayer

func _ready():
	pass

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "fade_in":
		ANIMATION_PLAYER.play("fade_out")

func update_scene():
	ANIMATION_PLAYER.play("fade_in")
