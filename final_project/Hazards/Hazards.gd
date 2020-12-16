extends Area2D



func _on_SpikeTop_body_entered(body):
	if body.has_method("hurt"):
#		body.hurt()
		get_tree().call_group("GameState", "hurt")
