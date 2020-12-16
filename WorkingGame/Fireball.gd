extends KinematicBody2D

export var speed:int = 800

var velocity = Vector2()
var direction = 1

func start(pos, dir):
	position = pos
	direction = dir
	if direction == 1:
		velocity = Vector2(speed, 0)
	else:
		velocity = Vector2(-speed, 0)
		
func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	
	if direction == 1:
		$Fireball.flip_h = true
		$fireball_collision.position.x *= -1
		$FireballDamage.position.x *= -1
	else:
		$Fireball.flip_h = false
		$fireball_collision.position.x *= -1
		$FireballDamage.position.x *= -1
		
	$Fireball.play("shoot")
	
	if collision:
		if collision.collider.has_method("interact"):
			collision.collider.interact()
		queue_free()
	
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
