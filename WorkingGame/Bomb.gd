extends KinematicBody2D

const THROW_VELOCITY = Vector2(3 * GlobalVars.UNIT_SIZE, -400)

var velocity = Vector2.ZERO
var count = 0

export (NodePath) var entity_path = ".."

onready var entity = get_node(entity_path)
onready var bomb_anim = $bomb_anim
onready var explosion = $explosion
onready var bomb_timer = $BombTimer
onready var damage = $BombDamage/CollisionShape2D

var shake

func _ready():
	damage.disabled = true
	match GlobalVars.selected_character:
		"knight":
			shake = get_node("../Knight/Camera/ScreenShake")
		"warrior":
			shake = get_node("../Player/Camera/ScreenShake")
		"adventurer":
			shake = get_node("../Adventurer/Camera/ScreenShake")

func _physics_process(delta):
	velocity.y += GlobalVars.gravity * delta
	var collision = move_and_collide(velocity * delta)
	
	if collision != null:
		_on_impact(collision.normal)

func launch(pos, direction):
	position = pos
	velocity = THROW_VELOCITY * Vector2(direction, 1)

func _on_impact(normal : Vector2):
	velocity = velocity.bounce(normal)
	velocity *= 0.5 + rand_range(-0.05, 0.05)
	
	if velocity.x <= 1 and count < 1:
		count = 1
		_start()
		
func _start():
	bomb_anim.play("bomb_explode")
	bomb_timer.start()


func _on_BombTimer_timeout():
	bomb_anim.hide()
	explosion.show()
	explosion.play("explosion")
	damage.disabled = false
	#GlobalSound.play_sound("explode", false, global_transform.origin)
	shake.start()
	yield(get_tree().create_timer(1), "timeout")
	self.queue_free()
	
