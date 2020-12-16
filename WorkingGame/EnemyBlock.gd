extends KinematicBody2D

var velocity = Vector2()

export var speed = 200
export var damage = 10
#Type should be UD for up/down or LR for left/right
export (String) var type
#Bool true for up or right, false for start left or down
export (bool) var dir

func _ready():
	if type == "UD":
		$Up.enabled = true
		$Down.enabled = true
		$Left.enabled = false
		$Right.enabled = false
	if type == "LR":
		$Up.enabled = false
		$Down.enabled = false
		$Left.enabled = true
		$Right.enabled = true
		
func _physics_process(delta):
	if type == "UD":
		if dir == true:
			velocity.y = -speed
		else:
			velocity.y = speed
		if $Up.is_colliding() and $Up.get_collider().get("TYPE") == null and dir == true:
			dir = false
		if $Down.is_colliding() and $Down.get_collider().get("TYPE") == null and dir == false:
			dir = true
			
	if type == "LR":
		if dir == true:
			velocity.x = speed
		else:
			velocity.x = -speed
		if $Right.is_colliding() and $Right.get_collider().get("TYPE") == null and dir == true:
			dir = false
		if $Left.is_colliding() and $Left.get_collider().get("TYPE") == null and dir == false:
			dir = true
	
	velocity = move_and_slide(velocity)
	
func _on_Area2D_area_entered(area):
	if area is Hitbox:
		if area.entity.has_method("damage"):
			area.entity.damage(damage)
