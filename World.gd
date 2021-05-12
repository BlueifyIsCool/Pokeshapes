extends Node2D

var L

var playerHealth
var level
var playerExp
var expforLevel

func _ready():
	Global.saveGame = true
	$Save.start()

func _process(_delta):
	playerHealth = Global.playerHealth
	level = Global.level
	playerExp = Global.playerExp
	expforLevel = Global.expforLevel
	
	if Global.encounter == 10:
		L = get_tree().change_scene("res://resources/Scenes/Loading.tscn")
	
func _on_Save_timeout():
	Global.saveGame = false
