extends KinematicBody2D

export var gravity:int = 1200
export var run_speed:int = 200
const FLOOR = Vector2(0, -1)

var max_health = 30
var health = max_health
var dead = false
var velocity = Vector2()

var direction = 1

func _ready():
	pass 

# warning-ignore:unused_argument
func _physics_process(delta):
	if not dead:
		velocity.x = run_speed * direction
		velocity.y += gravity
		
		if direction == 1:
			$AnimatedSprite.flip_h = false
		else:
			$AnimatedSprite.flip_h = true
			
		$AnimatedSprite.play("walk")
		
		velocity = move_and_slide(velocity, FLOOR)

		if is_on_wall():
			direction *= -1
			$LedgeDetect.position.x *= -1
			
		if $LedgeDetect.is_colliding() == false:
			direction *= -1
			$LedgeDetect.position.x *= -1
	
func damage(amount):
	_set_health(health - amount)
	
func dead():
	dead = true
	$AnimatedSprite.play("dead")
	$CollisionPolygon2D.set_deferred("disabled", true)
	yield(get_tree().create_timer(1.0), "timeout")
	queue_free()
	
func _set_health(value):
	var prev_health = health
	health = clamp(value, 0, max_health)
	if health < max_health:
		run_speed = run_speed / 2
		if health == 0:
			dead()
	
	
	
	
	
