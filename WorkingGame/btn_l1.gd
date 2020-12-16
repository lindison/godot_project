extends TextureButton

onready var transition = get_node("../../SceneTransition")
onready var transition_player = get_node("../../SceneTransition/Transition")

enum {
	IN_PROGRESS,
	COMPLETED,
	DISABLED,
}

var status

func _ready():
	status = GlobalLevel.level1
	
	match status:
		IN_PROGRESS:
			self.texture_normal = texture_normal
			self.disabled = false
		COMPLETED:
			self.texture_normal = texture_pressed
			self.disabled = false
		DISABLED:
			self.texture_normal = texture_disabled
			self.disabled = true

func _on_btn_l1_pressed():
	transition._fade_out()
	yield(transition_player, "animation_finished")
	GlobalVars.selected_level = "res://level1.tscn"
	Global.goto_scene("res://CharacterSelect.tscn")
