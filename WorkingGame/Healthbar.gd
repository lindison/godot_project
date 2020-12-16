extends Control

signal pulse()

onready var health_over = $HealthOver
onready var health_under = $HealthUnder
onready var update_tween = $UpdateTween
onready var pulse_tween = $PulseTween
onready var flash_tween = $FlashTween
onready var parent = get_parent()

export (Color) var healthy_color = Color.green
export (Color) var caution_color = Color.yellow
export (Color) var danger_color = Color.red
export (Color) var pulse_color = Color.darkred
export (Color) var flash_color = Color.orangered
export (float, 0, 1, 0.05) var caution_zone = 0.5
export (float, 0, 1, 0.05) var danger_zone = 0.2
export (bool) var will_pulse = true



func _on_max_health_update(max_health):
	health_over.max_value = max_health
	health_under.max_value = max_health
	
func _on_Player_health_updated(health):
	health_over.value = health
	update_tween.interpolate_property(health_under, "value", health_under.value, health, 0.4, Tween.TRANS_SINE, Tween.EASE_IN_OUT, 0.4)
	update_tween.start()
	
	_assign_color(health)
	
	
func _assign_color(health):
	if health == 0:
		pulse_tween.set_active(false)
	elif health < health_over.max_value * danger_zone:
		if will_pulse:
			if !pulse_tween.is_active():
				pulse_tween.interpolate_property(health_over, "tint_progress", pulse_color, danger_color, 1.2, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
				pulse_tween.interpolate_callback(self, 0.0, "emit_signal", "pulse")
				pulse_tween.start()
		else:
			health_over.tint_progress = danger_color
			
	else:
		pulse_tween.set_active(false)
		if health < health_over.max_value * caution_zone:
			health_over.tint_progress = caution_color
		else:
			health_over.tint_progress = healthy_color