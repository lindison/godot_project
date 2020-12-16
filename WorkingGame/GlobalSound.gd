extends Node

const AUDIO_PLAYER = preload("res://AudioPlayer.tscn")

var created_audio = []
var audio_clips = {
	"explode" : preload("res://Music/explode.wav")
}

func play_sound(sound_name, loop_sound = false, sound_position = null):
	if audio_clips.has(sound_name):
		var new_audio = AUDIO_PLAYER.instance()
		new_audio.should_loop = loop_sound
		
		add_child(new_audio)
		created_audio.append(new_audio)
		
		new_audio.play_sound(audio_clips[sound_name], sound_position)
	
	else:
		print("Error: cannot play sound, does not exist in audio_clips")
		
func _clear_audio_queue():
	for sound in created_audio:
		if sound != null:
			sound.queue_free()
	created_audio.clear()
