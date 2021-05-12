extends Control
var r
# Enemy GUI
onready var background = get_node("ColorRect")
onready var enemystatsBackground = get_node("ColorRect/EnemyStats")
onready var enemyHealthBar = get_node("ColorRect/EnemyStats/ProgressBar")
onready var enemyLevelGui = get_node("ColorRect/EnemyStats/Level")
# Player GUI
onready var playerstatsBackground = get_node("ColorRect/PlayerStats")
onready var playerHealthBar = get_node("ColorRect/PlayerStats/ProgressBar")
onready var healthText = get_node("ColorRect/PlayerStats/HealthText")
onready var xpText = get_node("ColorRect/PlayerStats/XP")
onready var playerLevelGui = get_node("ColorRect/PlayerStats/Level")
# PlayerActions GUI
onready var text = get_node("ColorRect/Tab/TextTab/Label")
onready var actionTab = get_node("ColorRect/Tab/ActionsTab")
onready var fightButton = get_node("ColorRect/Tab/ActionsTab/Fight")
onready var itemButton = get_node("ColorRect/Tab/ActionsTab/Items")
onready var pokemonButton = get_node("ColorRect/Tab/ActionsTab/Pokemon")
onready var runButton = get_node("ColorRect/Tab/ActionsTab/Run")

onready var skillBackground = get_node("ColorRect/Tab/ColorRect")
onready var move1 = get_node("ColorRect/Tab/ColorRect/Move1")
onready var move2 = get_node("ColorRect/Tab/ColorRect/Move2")
onready var move3 = get_node("ColorRect/Tab/ColorRect/Move3")
onready var move4 = get_node("ColorRect/Tab/ColorRect/Move4")

# Sprites
onready var playerPokemon = get_node("PlayerPokemon")
onready var enemyPokemon = get_node("EnemyPokemon")
onready var attacktimer = get_node("EnemyAttack")
# Enemy + Player Stats
var playerHealth
var maxplayerHealth
var playerExp
var playerLevel
var expNext
var skill1
var skill2
var skill3
var skill4

var skill1Pressed = false
var skill2Pressed = false
var skill3Pressed = false
var skill4Pressed = false

var enemyLevel = 0
var enemyHealth = 0
var maxEnemyHealth
var enemyDamage = 0
var enemy_randomized = false

var enemyAttack = false

var fight_pressed = false

var pokemonPressedNum = 0

var itemPressedNum = 0
var maxItemPressed = 100
var alreadyGet = false

var runPressedNum = 0

func _ready():
	pass
	
func _process(_delta):
	randomize()
	playerHealth = Global.playerHealth
	maxplayerHealth = Global.maxPlayerHealth
	playerLevel = Global.level
	playerExp = Global.playerExp
	expNext = Global.expforLevel
	skill1 = Global.skill1
	skill2 = Global.skill2
	skill3 = Global.skill3
	skill4 = Global.skill4
	
	if not enemy_randomized:
		enemy_randomized = true
		enemyLevel = rand_range(1, 2) + playerLevel - playerLevel - Global.kills
		enemyHealth = rand_range(10, 20) * enemyLevel - playerLevel
		enemyDamage = rand_range(2, 4) * enemyLevel / 2
		enemyLevel = int(round(enemyLevel))
		enemyHealth = int(round(enemyHealth))
		enemyDamage = int(round(enemyDamage))
		maxEnemyHealth = enemyHealth
	
	itemPressedNum = clamp(itemPressedNum, 0, 100)
	enemyHealth = clamp(enemyHealth, 0, 1000)
	
	if playerHealth <= 0:
		playerPokemon.visible = false
	if enemyHealth <= 0:
		Global.playerExp += enemyDamage
		Global.kills += 1
		get_tree().reload_current_scene()
		r = get_tree().change_scene("res://resources/Scenes/World.tscn")

	# Set Text
	healthText.set_text(str(playerHealth, " / ", maxplayerHealth))
	playerLevelGui.set_text(str("LV ", playerLevel))
	xpText.set_text(str("XP: ", playerExp, " / ", expNext))
	enemyLevelGui.set_text(str("LV ", enemyLevel))
	# Set Value
	playerHealthBar.value = Global.playerHealth
	playerHealthBar.set_deferred("max_value", maxplayerHealth)
	enemyHealthBar.value = enemyHealth
	enemyHealthBar.max_value = maxEnemyHealth
	
	match fight_pressed:
		true:
			skillBackground.rect_position = Vector2(408, 8)
			actionTab.rect_position = Vector2(408, 136)
			skillBackground.visible = true
			fightButton.disabled = true
			itemButton.disabled = true
			pokemonButton.disabled = true
			runButton.disabled = true
		false:
			skillBackground.rect_position = Vector2(408, 136)
			actionTab.rect_position = Vector2(408, 8)
			skillBackground.visible = false
			fightButton.disabled = false
			itemButton.disabled = false
			pokemonButton.disabled = false
			runButton.disabled = false
	
	match[skill1Pressed,skill2Pressed,skill3Pressed,skill4Pressed]:
		[true,false,false,false]:
			text.set_text("Triangle, used Pound.")
			skill1Pressed = false
			enemyHealth -= 2 * playerLevel
			attacktimer.start()
		[false,true,false,false]:
			text.set_text("Triangle, used Absorb.")
			skill2Pressed = false
			enemyHealth -= 5 * playerLevel
			Global.playerHealth += 5 * playerLevel
			attacktimer.start()
		[false,false,true,false]:
			text.set_text("Triangle, used Sharp Tackle.")
			skill3Pressed = false
			enemyHealth -= 10 * playerLevel
			attacktimer.start()
		[false,false,true,false]:
			text.set_text("Triangle, used Destroy.")
			skill4Pressed = false
			enemyHealth -= 20 * playerLevel
			attacktimer.start()
	
func attacks():
	match[skill1,skill2,skill3,skill4]:
		[true,false,false,false]:
			move1.set_text("Pound")
			move1.disabled = false
		[false,true,false,false]:
			move2.set_text("Absorb")
			move2.disabled = false
		[false,false,true,false]:
			move3.set_text("Sharp Tackle")
			move3.disabled = false
		[false,false,false,true]:
			move4.set_text("Destroy")
			move4.disabled = false
func _on_Fight_pressed():
	fight_pressed = true
	if skill1:
		move1.disabled = false
	if skill2:
		move2.disabled = false
	if skill3:
		move3.disabled = false
	if skill4:
		move4.disabled = false
	attacks()
func _on_Pokemon_pressed():
	text.set_text("You don't have any other pokemon.")
func _on_Items_pressed():
	print(itemPressedNum)
	if not alreadyGet:
		itemPressedNum += 1
	if itemPressedNum <= 10:
		text.set_text("You do not have items.")
	if itemPressedNum == 10:
		text.set_text("You don't have any items though...")
	if itemPressedNum == 20:
		text.set_text("Stop, I said you don't have any items.")
	if itemPressedNum == 30:
		text.set_text("Being stubborn huh?")
	if itemPressedNum == 40:
		text.set_text("I just said there is NOTHING in your bag.")
	if itemPressedNum == 50:
		text.set_text("Stop clicking this button..")
	if itemPressedNum == 100:
		text.set_text("Okay fine here you go a free potion.")
		Global.playerHealth += 20
		alreadyGet = true
		itemButton.disabled = true
func _input(_event):
	if Input.is_action_just_pressed("ui_accept"):
		print(enemyHealth)
		
	
func _on_Run_pressed():
	text.set_text("What? Are you a coward?")
	
func _on_Move1_pressed():
	skill1Pressed = true
	move1.set_deferred("disabled", true)
	
func _on_Move2_pressed():
	skill2Pressed = true
	move2.set_deferred("disabled", true)
	
func _on_Move3_pressed():
	skill3Pressed = true
	move3.set_deferred("disabled", true)
	
func _on_Move4_pressed():
	skill4Pressed = true
	move4.set_deferred("disabled", true)
	
func _on_EnemyAttack_timeout():
	fight_pressed = false
	Global.playerHealth -= enemyDamage
	text.set_text("Enemy Cube, used Tackle.")
	
