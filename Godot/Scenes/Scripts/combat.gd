extends Node2D

@export var noteScene : PackedScene
var timer : Timer
var enemy

var goodNote
var okNote
var notes

var minigameActive
var killEnemy
var partSprite

var questReward
var rewardQuantity

var player : Dictionary

var dir:Dictionary

signal combat_done()

# Called when the node enters the scene tree for the first time.
func _ready():
	notes = $Minigame/Notes
	timer = $Timer
	enemy = $EnemyScreen/Enemy
	partSprite = $EnemyScreen/PartSprite
	dir["Left"] = 0
	dir["Up"] = 1
	dir["Right"] = 2
	dir["Down"] = 3
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if minigameActive:
		for inp in dir.keys():
			if Input.is_action_just_pressed(inp):
				check(inp)
	if killEnemy:
		if enemy.modulate.a  > 0:
			enemy.modulate.a -= 2*delta
		else:
			if partSprite.visible == false:
				timer.start(3)
			partSprite.visible = true
	pass

func start(quest):
	# set display stuff
	player["attack"] = Storage.get_attack()
	player["defense"] = Storage.get_defense()
	player["hp"] = 100
	for note in notes.get_children():
		note.queue_free()
	
	questReward = quest.questMaterial
	rewardQuantity = 0
	partSprite.visible = false
	partSprite.set_part(questReward)
	enemy.set_enemy(quest.questEnemy)
	enemy.modulate.a = 1
	goodNote == null
	okNote == null
	minigameActive = true
	killEnemy = false
	
	var n = noteScene.instantiate()
	notes.add_child(n)
	n.position = Vector2(0,0)
	timer.start(randf_range(.5,2))
	pass

func end_minigame():
	minigameActive = false
	for note in notes.get_children():
		note.queue_free()

func check(inp):
	# if no note or pressed wrong direction
	if okNote == null or dir[inp] != okNote.dir:
		hit_player()
		return
		
	if goodNote != null:
		hit_enemy(.5)
	else:
		hit_enemy()
	okNote.queue_free()
	goodNote = null
	okNote = null

func hit_player():
	player["hp"] -= get_damage(enemy.stats.attack,player["defense"])
	pass

func hit_enemy(crit = 0):
	var damage = get_damage(player["attack"],enemy.stats.defense)
	if damage > 0:
		enemy.hit()
	if randf()<crit:
		enemy.stats.hp -= damage * 2
	else:
		enemy.stats.hp -= damage
	if enemy.stats.hp <= 0:
		end_minigame()
		killEnemy = true
		rewardQuantity = 1
		timer.stop()
	pass

func get_damage(attack, defense):
	var damage = attack - defense
	if damage > 0:
		return damage
	elif randf() < attack/defense:
		return 1
	else:
		return 0

# detect notes
func _on_good_area_entered(area):
	if area.is_in_group("Note"):
		goodNote = area
	pass # Replace with function body.

func _on_good_area_exited(_area):
	goodNote = null
	pass # Replace with function body.

func _on_ok_area_entered(area):
	if area.is_in_group("Note"):
		okNote = area
	pass # Replace with function body.

func _on_ok_area_exited(_area):
	okNote = null
	pass # Replace with function body.

func _on_timer_timeout():
	if killEnemy:
		timer.stop()
		Storage.add_part(questReward, rewardQuantity)
		emit_signal("combat_done")
	elif player["hp"] <= 0:
		emit_signal("combat_done")
		timer.stop()
	else:
		var n = noteScene.instantiate()
		notes.add_child(n)
		n.position = Vector2(0,0)
		timer.start(randf_range(.2,1.5))
	pass # Replace with function body.


func _on_kill_area_entered(area):
	if area.is_in_group("Note"):
		hit_player()
	area.queue_free()
	pass # Replace with function body.
