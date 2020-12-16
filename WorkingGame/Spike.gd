extends Node2D


export var damage = 30

func _on_Area2D_area_entered(area):
	$SpikeAnim.play("Spike")



func _on_Area2D_area_exited(area):
	$SpikeAnim.play_backwards("Spike")
	


func _on_Hit_area_entered(area):
	if area is Hitbox:
		if area.entity.has_method("damage"):
			area.entity.damage(damage)
