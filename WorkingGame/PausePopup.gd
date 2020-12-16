extends Popup

func _ready():
	$ColorRect/Button.grab_focus()

func _physics_process(delta):
	if $ColorRect/Button.is_hovered():
		$ColorRect/Button.grab_focus()


func _input(event):
	if event.is_action_pressed("pause"):
		if GlobalVars.game_over == false:
			$ColorRect/Button.grab_focus()
			get_tree().paused = not get_tree().paused
			visible = not visible


func _on_Button_pressed():
	visible = not visible
	get_tree().paused = not get_tree().paused
