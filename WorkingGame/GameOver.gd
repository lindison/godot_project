extends Popup

func _on_death():
	GlobalVars.game_over = true
	get_tree().paused = true
	visible = true

func _on_Restart_pressed():
	visible = false
	get_tree().paused = false
	GlobalVars.game_over = false
	Global.goto_scene(GlobalVars.selected_level)

func _on_LevelSelect_pressed():
	visible = false
	get_tree().paused = false
	GlobalVars.game_over = false
	Global.goto_scene("res://LevelSelect.tscn")

func _on_CharacterSelect_pressed():
	visible = false
	get_tree().paused = false
	GlobalVars.game_over = false
	Global.goto_scene("res://CharacterSelect.tscn")
