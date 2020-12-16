extends Node2D

var timer:Timer = Timer.new()
var dust = preload("res://Dust.tscn")
var rand = RandomNumberGenerator.new()
onready var screen_size = get_viewport().get_visible_rect().size

func _ready():
	yield(get_tree().create_timer(1),"timeout")
	_create_timer()
	timer.start()
	
func _create_timer():
	var ran = rand.randf_range(1.0, 3.0)
	timer.set_one_shot(false)
	timer.set_wait_time(ran)
	timer.connect("timeout", self, "_add_dust")
	add_child(timer)

func _add_dust():
	var dos = dust.instance()
	rand.randomize()
	var x = rand.randf_range(0, screen_size.x)
	rand.randomize()
	var y = rand.randf_range(0, screen_size.y)
	
	dos.position.x = x
	dos.position.y = y
	add_child(dos)
