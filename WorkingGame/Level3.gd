extends Node2D


# Declare member variables here. Examples:
var action = Input.is_action_pressed("action")
var areaEntered = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if action:
		if areaEntered:
			print (areaEntered)
		

func _on_Area2D_area_entered(area):
	areaEntered = true
	print(areaEntered)
	if $Platform/Elevator.current_animation_position == 0:
		$Platform/Elevator.play("Elevator")
	elif $Platform/Elevator.current_animation_position == 1:
		$Platform/Elevator.play_backwards("Elevator")
	
	var current_frame = $Switch.get_frame()
	
	if current_frame == 0:
		$Switch.play("default")
	else:
		$Switch.play("default", true)
	
