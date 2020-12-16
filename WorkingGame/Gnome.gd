extends KinematicBody2D

# I secretly need you

const UP = Vector2(0, -1)
const SLOPE_STOP = 32

var velocity = Vector2()
var move_speed = 5 * GlobalVars.UNIT_SIZE
var move_direction = 0
var gravity = 1200
var facing = 1

func _physics_process(delta):
	move_direction = -int(Input.is_action_pressed("left")) + int(Input.is_action_pressed("right"))
	velocity = move_and_slide(velocity, UP, SLOPE_STOP)
	velocity.x = lerp(velocity.x, move_speed * move_direction, _get_h_weight())
	velocity.y += gravity * delta
	
	if Input.is_action_pressed("left"):
		facing = -1
	elif Input.is_action_pressed("right"):
		facing = 1
		
		
	if move_direction != 0:
		$CharacterRig.set_scale(Vector2(facing, 1))
		$CharacterRig/AnimationPlayer.play("run")
	else:
		$CharacterRig/AnimationPlayer.play("idle")
		
func _get_h_weight():
	return 0.2 if is_on_floor() else 0.1
