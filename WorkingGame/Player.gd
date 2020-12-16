extends KinematicBody2D

signal grounded_updater(is_grounded)
signal health_updated(health)
signal death()

const UP = Vector2(0,-1)
const SLOPE_STOP = 16
const DROP_THROUGH = 8
const WALL_JUMP_VELOCITY = Vector2(3 * GlobalVars.UNIT_SIZE, -500)

var fireball = preload("res://Fireball.tscn")
var bomb = preload("res://Bomb.tscn")
var velocity = Vector2()

var move_speed = 5 * GlobalVars.UNIT_SIZE
var dash_velocity = 3 * move_speed
var gravity
var max_jump_velocity
var min_jump_velocity
var jump_count = 0
var is_grounded
var was_grounded
var is_jumping = false
var facing = 1
var wall_direction = 1
var move_direction
var prev_position = Vector2()
var can_dash = true
var dash_timer = Timer.new()

var max_jump_height = 2.25 * GlobalVars.UNIT_SIZE
var min_jump_height = 0.8 * GlobalVars.UNIT_SIZE
var jump_duration = 0.5

export (float) var max_health = 100

onready var health = max_health setget _set_health
onready var healthbar = $Healthbar
onready var ground = $CheckGround
onready var anim_player = $AnimatedSprite
onready var mid_check = $CheckGround/Middle

onready var left_wall_raycasts = $WallRaycasts/LeftWallRaycasts
onready var right_wall_raycasts = $WallRaycasts/RightWallRaycasts

onready var wall_slide_cooldown = $WallSlideCooldown
onready var wall_slide_sticky_timer = $WallSlideStickyTimer
onready var invulnerability_timer = $InvulnerabilityTimer
onready var damage_animation = $DamageAnimation

func _ready():
	$Light.enabled = false
	gravity = 2 * max_jump_height / pow(jump_duration, 2)
	healthbar._on_max_health_update(max_health)
	GlobalVars.gravity = gravity
	max_jump_velocity = -sqrt(2 * gravity * max_jump_height)
	min_jump_velocity = -sqrt(2 * gravity * min_jump_height)
	_create_timer()
	
func start(pos):
	position = pos
	show()

func _create_timer():
	dash_timer.set_one_shot(true)
	dash_timer.set_wait_time(1)
	dash_timer.connect("timeout", self, "dash_again")
	add_child(dash_timer)
	
func dash_again():
	can_dash = true
	
func _apply_gravity(delta):
	velocity.y += gravity * delta
	if is_jumping and velocity.y >= 0:
		is_jumping = false
	
func _update_move_direction():
	move_direction = -int(Input.is_action_pressed("left")) + int(Input.is_action_pressed("right"))
	
func _handle_move_input():
	
	velocity.x = lerp(velocity.x, move_speed * move_direction, _get_h_weight())
	
	if move_direction != 0:
		$AnimatedSprite.flip_h = move_direction < 0
	
	if Input.is_action_pressed("left"):
		facing = -1
	elif Input.is_action_pressed("right"):
		facing = 1
	

func _apply_movement():
	
	
	velocity = move_and_slide(velocity, UP, SLOPE_STOP)
	
	var was_grounded = is_grounded
	
	is_grounded = not is_jumping and check_is_grounded()
	
	if was_grounded == null or is_grounded != was_grounded:
		emit_signal("grounded_updater", is_grounded)
		
	if self.is_on_floor():
		jump_count = 0

func _get_h_weight():
	return 0.2 if is_grounded else 0.1
	
func _update_previous_position():
	if check_is_grounded():
		if mid_check.is_colliding():
			var mid = mid_check.get_collision_point()
			if facing == 1:
				prev_position = Vector2(mid.x - 50, mid.y - 100)
			else:
				prev_position = Vector2(mid.x + 50, mid.y - 100)

func check_is_grounded():
	for g in ground.get_children():
		if g.is_colliding():
			return true
	return false

func _handle_wall_slide_sticking():
	if move_direction != 0 and move_direction != wall_direction:
		if wall_slide_sticky_timer.is_stopped():
			wall_slide_sticky_timer.start()
	else:
		wall_slide_sticky_timer.stop()

func _update_wall_direction():
	var is_near_left_wall = _check_is_valid_wall(left_wall_raycasts)
	var is_near_right_wall = _check_is_valid_wall(right_wall_raycasts)
	
	if is_near_left_wall and is_near_right_wall:
		wall_direction = move_direction
	else:
		wall_direction = -int(is_near_left_wall) + int(is_near_right_wall)
	
func _check_is_valid_wall(wall_raycasts):
	for raycast in wall_raycasts.get_children():
		if raycast.is_colliding():
			var dot = acos(Vector2.UP.dot(raycast.get_collision_normal()))
			if dot > PI * 0.35 and dot < PI * 0.55:
				return true
	return false	

func _interact():
	var object_interact = $CheckInteract.get_collider()
	if object_interact != null:
		print(object_interact)
		if object_interact.has_method("interact"):
			object_interact.interact()

func shoot():
	var f = fireball.instance()
	f.start($fire.global_position, facing)
	get_parent().add_child(f)
	
func _throw_bomb():
	var b = bomb.instance()
	b.launch($fire.global_position, facing)
	get_parent().add_child(b)
	
func _on_dash(delta):
	can_dash = false
	velocity = Vector2(dash_velocity * facing, 0)
	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity = Vector2(collision.normal)
	dash_timer.start()
	
func _jump():
	#$JumpSound.play()
	velocity.y = max_jump_velocity
	is_jumping = true
	
func _variable_jump():
	velocity.y = min_jump_velocity
	
func _wall_jump():
	var wall_jump_velocity = WALL_JUMP_VELOCITY
	wall_jump_velocity.x *= -wall_direction
	velocity = wall_jump_velocity
	
func _cap_wall_movement():
	var max_velocity = 2 * GlobalVars.UNIT_SIZE if !Input.is_action_pressed("down") else 5 * GlobalVars.UNIT_SIZE
	velocity.y = min(velocity.y, max_velocity)
	
func damage(amount):
	if invulnerability_timer.is_stopped():
		invulnerability_timer.start()
		_set_health(health - amount)
		damage_animation.play("damage")
		damage_animation.queue("flash")	

func dead():
	pass
	
func _set_health(value):
	var prev_health = health
	health = clamp(value, 0, max_health)
	if health != prev_health:
		emit_signal("health_updated", health)
		if health == 0:
			dead()
			emit_signal("death")
			
func _light():
	$Light.enabled = true
	
func _light_off():
	$Light.enabled = false

func _on_Area2D_body_exited(body):
	self.set_collision_mask_bit(DROP_THROUGH, true)


func _on_ScreenExit_screen_exited():
	position = prev_position


func _on_InvulnerabilityTimer_timeout():
	damage_animation.play("idle")
