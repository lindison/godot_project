extends ColorRect

onready var _anim_player = $Transition

func _ready():
	_anim_player.play_backwards("Fade")

func _fade_out():
	_anim_player.play("Fade")
