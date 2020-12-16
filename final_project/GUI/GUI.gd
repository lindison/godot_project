extends CanvasLayer

func _ready():
	$Control/TextureRect/HBoxContainer/LifeCount.text = "3"
	
func update_GUI(lives_left, coins):
	print(lives_left)
	$Control/TextureRect/HBoxContainer/LifeCount.text = str(lives_left)
	$Control/TextureRect/HBoxContainer/CoinCount.text = str(coins)
