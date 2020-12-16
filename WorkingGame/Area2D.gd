extends Area2D

func interact():
	var elevator = get_node("../../Platform/Elevator")
	if elevator.current_animation_position == 0:
		elevator.play("Elevator")
	elif elevator.current_animation_position == 1:
		elevator.play_backwards("Elevator")

	var current_frame = $Switch.get_frame()

	if current_frame == 0:
		$Switch.play("default")
	else:
		$Switch.play("default", true)
