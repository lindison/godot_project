extends "res://StateMachine.gd"

func _ready():
	add_state("idle")
	add_state("fall")
	add_state("run")
	add_state("jump")
	add_state("dash")
	add_state("wall_slide")
	call_deferred("set_state", states.idle)
	
func _input(event):
	if [states.idle, states.run].has(state):
		if event.is_action_pressed("jump"):
			if Input.is_action_pressed("down"):
				parent.set_collision_mask_bit(parent.DROP_THROUGH, false)
			else:
				parent._jump()
				parent.jump_count += 1
		elif event.is_action_pressed("dash") and PowerUps.dash and parent.can_dash:
			set_state(states.dash)
			yield(get_tree().create_timer(0.5), "timeout")
			set_state(states.idle)
			
	elif state == states.wall_slide:
		if event.is_action_pressed("jump"):
			parent._wall_jump()
			set_state(states.jump)
	
	elif [states.jump, states.fall].has(state):
		if parent.jump_count < 2 and event.is_action_pressed("jump") and PowerUps.double_jump:
			parent._jump()
			parent.jump_count +=1
			
	if state == states.jump:
		if event.is_action_released("jump") and parent.velocity.y < parent.min_jump_velocity:
			parent._variable_jump()
	
	
	if [states.idle, states.run, states.jump, states.fall].has(state):
		if Input.is_action_just_pressed("shoot"):
			parent.shoot()
		elif Input.is_action_just_pressed("throw"):
			parent._throw_bomb()
			
	if Input.is_action_just_pressed("testlevelselect"):
		Global.goto_scene("res://LevelSelect.tscn")
		
	if Input.is_action_pressed("interact"):
		print('interact')
		parent._interact()
			
func _state_logic(delta):
	parent._update_move_direction()
	parent._update_previous_position()
	if state != states.dash:
		parent._update_wall_direction()
		
		if state != states.wall_slide:
			parent._handle_move_input()
			
		parent._apply_gravity(delta)
		
		if state == states.wall_slide:
			parent._cap_wall_movement()
			parent._handle_wall_slide_sticking()
		
		parent._apply_movement()
	else:
		parent._on_dash(delta)
	
func _get_transition(delta):
	match state:
		states.idle:
			if not parent.is_grounded:
				if parent.velocity.y < 0:
					return states.jump
				elif parent.velocity.y > 0:
					return states.fall
			elif parent.velocity.x != 0:
				return states.run
		states.run:
			if not parent.is_grounded:
				if parent.velocity.y < 0:
					return states.jump
				elif parent.velocity.y > 0:
					return states.fall
			elif parent.velocity.x == 0:
				return states.idle
		states.jump:
			if parent.wall_direction != 0 and parent.wall_slide_cooldown.is_stopped():
				return states.wall_slide
			elif parent.is_grounded:
				return states.idle
			elif parent.velocity.y >= 0:
				return states.fall
		states.fall:
			if parent.wall_direction != 0 and parent.wall_slide_cooldown.is_stopped():
				return states.wall_slide
			elif parent.is_grounded:
				return states.idle
			elif parent.velocity.y < 0:
				return states.jump
		states.wall_slide:
			if parent.is_grounded:
				return states.idle
			elif parent.wall_direction == 0:
				return states.fall
	return null
	
func _enter_state(new_state, old_state):
	match new_state:
		states.idle:
			parent.anim_player.play("idle")
		states.run:
			parent.anim_player.play("walk")
		states.jump:
			parent.anim_player.play("jump")
		states.fall:
			parent.anim_player.play("fall")
		states.dash:
			parent.anim_player.play("walk")
		states.wall_slide:
			parent.anim_player.play("wall_slide")
			
func _exit_state(old_state, new_state):
	match old_state:
		states.wall_slide:
			parent.wall_slide_cooldown.start()


func _on_WallSlideStickyTimer_timeout():
	if state == states.wall_slide:
		set_state(states.fall)
