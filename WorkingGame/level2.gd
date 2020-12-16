extends Node2D

#onready var light = get_node("../../Light")
onready var knight = preload("res://Knight.tscn").instance()
onready var adventurer = preload("res://Adventurer.tscn").instance()
onready var warrior = preload("res://Player.tscn").instance()
onready var start_position = $StartPosition
onready var selected_character = GlobalVars.selected_character

func _ready():
	match selected_character:
		"knight":
			knight.start(start_position.position)
			add_child(knight)
			adventurer.queue_free()
			warrior.queue_free()
		"warrior":
			warrior.start(start_position.position)
			add_child(warrior)
			knight.queue_free()
			adventurer.queue_free()
		"adventurer":
			adventurer.start(start_position.position)
			add_child(adventurer)
			knight.queue_free()
			warrior.queue_free()
	
#	light.set_visible(false)
#	if $Cave.is_visible():
#		$Cave.set_visible(false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


#func _on_Cave_body_entered(body):
#	light.set_visible(true)
#	$Cave.set_visible(true)
#
#
#func _on_Cave_body_exited(body):
#	light.set_visible(false)
#	$Cave.set_visible(false)
