extends Node

var selected_character:String = "warrior"

onready var warrior = $WarButton
onready var adventurer = $AdButton
onready var knight = $KnButton
onready var info = $InfoLabel
onready var war_anim = $WarAnim
onready var ad_anim = $AdAnim
onready var kn_anim	= $KnAnim

func _ready():
	info.text = "Select your character."
	war_anim.play("idle")
	ad_anim.play("idle")
	kn_anim.play("idle")

func _on_WarButton_pressed():
	warrior.pressed = true
	adventurer.pressed = false
	knight.pressed = false
	info.text = "Standard warrior"
	selected_character = "warrior"
	war_anim.play("run")
	ad_anim.play("idle")
	kn_anim.play("idle")


func _on_AdButton_pressed():
	warrior.pressed = false
	adventurer.pressed = true
	knight.pressed = false
	info.text = "Jumps higher, fewer hitpoints."
	selected_character = "adventurer"
	war_anim.play("idle")
	ad_anim.play("run")
	kn_anim.play("idle")
	
func _on_KnButton_pressed():
	warrior.pressed = false
	adventurer.pressed = false
	knight.pressed = true
	info.text = "Slower, can't jump as high, more hitpoints."
	selected_character = "knight"
	war_anim.play("idle")
	ad_anim.play("idle")
	kn_anim.play("run")
	
func _on_SelectButton_pressed():
	GlobalVars.selected_character = selected_character
	Global.goto_scene(GlobalVars.selected_level)
