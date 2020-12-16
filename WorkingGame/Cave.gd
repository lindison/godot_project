extends Area2D


func _ready():
	if self.is_visible():
		self.set_visible(false)
		


func _on_Cave_body_entered(body):
	self.set_visible(true)
	if body.has_method("_light"):
		body._light()


func _on_Cave_body_exited(body):
	self.set_visible(false)
	if body.has_method("_light_off"):
		body._light_off()
