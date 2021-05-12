extends KinematicBody2D

var speed = 500

var damage
var encounter = 0

func _physics_process(_delta):
	var velocity = Vector2()
	
	if Input.get_action_strength("ui_up"):
		velocity.y -= 1
	if Input.get_action_strength("ui_down"):
		velocity.y += 1
	if Input.get_action_strength("ui_right"):
		velocity.x += 1
	if Input.get_action_strength("ui_left"): 
		velocity.x -= 1
	
	if Input.get_action_strength("ui_accept"):
		speed = 700
	else:
		speed = 500
	
	velocity = velocity.normalized()
	velocity = move_and_slide(velocity * speed)
	
func _process(_delta):
	randomize()
	
	damage = rand_range(1, 100)
	
	Global.encounter = encounter
	Global.playerDamage = damage
	
func randomizeEncounter():
	encounter = rand_range(1,10)
	encounter = int(round(encounter))
	
func _on_EncounterHitbox_area_entered(area):
	if area.get_name() == "GrassHitbox":
		randomizeEncounter()
