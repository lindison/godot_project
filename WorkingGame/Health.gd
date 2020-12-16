extends Area2D

var damage = -50

func _on_Health_area_entered(area):
	if area is Hitbox:
		if area.entity.has_method("damage"):
			area.entity.damage(damage)
			queue_free()
