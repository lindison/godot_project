extends Control

var player_words = []
var template = [
		{
		"prompts" : ["city name" , "adjective" , "adjective" , "color" , "cartoon character" , "place" , "verb" , "animal"],
		"story" : "%s city is so exciting! Everything is so %s ! All the buildings are %s and there's a big river that's %s. I can't wait to see %s at the %s. Then we're going to go %s the %s."
		},
		{
		"prompts" : ["a name" , "a noun" , "action" , "adjective"],
		"story" : "Once upon a time %s , a %s person, %s in the face and was %s "
		}
		]
var current_story

onready var PlayerText = $VBoxContainer/HBoxContainer/PlayerText
onready var DisplayText = $VBoxContainer/DisplayText
onready var LabelText = $VBoxContainer/HBoxContainer/Label

func _ready():
	set_current_story()
	DisplayText.text = "Welcome to LooneyLips! "
	check_player_words_length()
	PlayerText.grab_focus()

func set_current_story():
	randomize()
	current_story = template[randi() % template.size()]

func _on_PlayerText_text_entered(new_text):
	add_to_player_words()

func _on_TextureButton_pressed():
	if is_story_done():
		get_tree().reload_current_scene()
	else:
		add_to_player_words()
	
func add_to_player_words():
	player_words.append(PlayerText.text)
	DisplayText.text = ""
	PlayerText.clear()
	check_player_words_length()

func is_story_done():
	return player_words.size() == current_story.prompts.size()
	
func check_player_words_length():
	if is_story_done():
		end_game()
	else:
		prompt_player()
		
func tell_story():
	DisplayText.text = current_story.story % player_words
	
func prompt_player():
	DisplayText.text += "May I have " + current_story.prompts[player_words.size()] + " please?"
	
func end_game():
	PlayerText.queue_free()
	tell_story()
	LabelText.text = "Again"
