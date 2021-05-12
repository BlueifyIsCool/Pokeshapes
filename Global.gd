extends Node

# Player Stats
var playerHealth = 15
var maxPlayerHealth = playerHealth
var kills = 0

var playerDamage
var level = 5
var playerExp = 0
var expforLevel = level + 20 + playerHealth
var skill1 = true
var skill2 = false
var skill3 = false
var skill4 = false

var skill1Damage = 5 * level
var skill2Damage = 10 * level

var pokemon = "Triangle"

# Game
var encounter = 0
var loadGame = false
var saveGame = false

func _process(_delta):
	
	playerHealth = clamp(playerHealth, 0, maxPlayerHealth)
	playerExp = clamp(playerExp, 0, expforLevel)
	
	match [loadGame,saveGame]:
		[true,false]:
			load_level()
		[false,true]:
			save_level()
			
	if playerExp == expforLevel:
		level += 1
	
	match level:
		1:
			skill1 = true
		10:
			skill2 = true
		30:
			skill3 = true
		70:
			skill4 = true
	
func load_level():
	var save_file = File.new()
	if not save_file.file_exists("res://Player_Data/savefile.save"):
		return
	save_file.open("res://Player_Data/savefile.save", File.READ)
	playerHealth = int(save_file.get_line())
	level = int(save_file.get_line())
	playerExp = int(save_file.get_line())
	expforLevel = int(save_file.get_line())
	print("Loaded")
	save_file.close()
# SAVE FUNCTION
func save_level():
	var save_file = File.new()
	save_file.open("res://Player_Data/savefile.save", File.WRITE)
	save_file.store_line(str(playerHealth))
	save_file.store_line(str(level))
	save_file.store_line(str(playerExp))
	save_file.store_line(str(expforLevel))
	print("Saved!")
	save_file.close()
	

