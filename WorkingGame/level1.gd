extends Node2D

onready var knight = preload("res://Knight.tscn").instance()
onready var adventurer = preload("res://Adventurer.tscn").instance()
onready var warrior = preload("res://Player.tscn").instance()
onready var start_position = $StartPosition
onready var selected_character = GlobalVars.selected_character
onready var game_over = $CanvasLayer/GameOver
onready var dj = $DoubleJump

func _ready():
	match selected_character:
		"knight":
			knight.start(start_position.position)
			add_child(knight)
			warrior.queue_free()
			adventurer.queue_free()
		"warrior":
			warrior.start(start_position.position)
			add_child(warrior)
			adventurer.queue_free()
			knight.queue_free()
		"adventurer":
			adventurer.start(start_position.position)
			add_child(adventurer)
			knight.queue_free()
			warrior.queue_free()
			
	if PowerUps.double_jump:
		dj.visible = false
func _on_death():
	game_over.popup()
	game_over._on_death()

func _on_DoubleJump_body_entered(body):
	PowerUps._double_jump()
	$DoubleJump.queue_free()
