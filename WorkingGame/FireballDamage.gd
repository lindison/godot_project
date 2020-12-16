extends Area2D


signal entity_damaged(entity)

export var damage = 15

var exceptions = []

onready var parent = get_parent()

func add_exception(node : Node):
	exceptions.append(node)
	
func remove_exception(node : Node):
	exceptions.erase(node)

func _on_FireballDamage_area_entered(area):
	if area is Hitbox:
		if !exceptions.has(area.entity) and area.entity.has_method("damage"):
			area.entity.damage(damage)
			parent.queue_free()