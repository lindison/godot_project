extends TextureRect


onready var transition = $SceneTransition
onready var transition_player = $SceneTransition/Transition

func _on_Start_pressed():
	transition._fade_out()
	yield(transition_player,"animation_finished")
	Global.goto_scene("res://LevelSelect.tscn")
