extends Node2D

@export var noteScene : PackedScene
@export var syncBar : PackedScene

# parts
var timer : Timer
var gameCols
var partSprite
var enemyHealth # current health
var enemyHealthBar # full bar

# states
var minigameActive
var killEnemy

# stats
var enemy
var noteSpeed
var enemyDamage
var playerDamage
var player : Dictionary

var accuracy
var totalNotes
var questReward

# note stuff
var goodNote :Array
var okNote :Array
var badNote :Array
var notes
var bars

signal combat_done()
signal player_death()
signal win()

func _ready():
	timer = $Timer
	enemy = $EnemyScreen/Enemy
	partSprite = $EnemyScreen/PartSprite
	enemyHealthBar = $Health/Enemy
	enemyHealth = $Health/Enemy/Current
	gameCols = $Minigame/cols.get_children()
	bars = $Minigame/Bars
	pass # Replace with function body.

func _process(delta):
	if killEnemy:
		if enemy.modulate.a  > 0:
			enemy.modulate.a -= 2*delta
			enemyHealthBar.modulate.a -= 2*delta
		else:
			if partSprite.visible == false:
				timer.start(2)
				# no drop if dragon
				if enemy.stats.type == "Dragon":
					partSprite.modulate.a = 0
				else:
					partSprite.modulate.a = 1
			partSprite.visible = true

func start(quest):
	# generic
	accuracy =0
	totalNotes = 0
	Stats.combats +=1
	
	killEnemy = false
	noteSpeed = Settings.noteSpeed
	
	for col in gameCols:
		col.speed = noteSpeed
		col.reset()
	
	match Settings.noteType:
		"letter":
			gameCols[0].position.x = 0
			gameCols[1].position.x = 100
			gameCols[2].position.x = 200
			gameCols[3].position.x = 300
		"arrow":
			gameCols[0].position.x = -20
			gameCols[1].position.x = 92.5
			gameCols[2].position.x = 207.5
			gameCols[3].position.x = 320
		_:
			gameCols[0].position.x = 0
			gameCols[1].position.x = 95
			gameCols[2].position.x = 205
			gameCols[3].position.x = 300
	
	# Enemy stuff
	$Health/Enemy/Name.text = quest.enemy
	enemy.set_enemy(quest.questEnemy)
	enemy.stats.heal()
	enemy.modulate.a = 1
	
	enemyHealth.size.x=enemyHealthBar.size.x
	$Health/Enemy/LastHit.text = ""
	enemyDamage = enemy.stats.attack
	enemyHealthBar.modulate.a = 1
	enemyHealth.size.x = enemyHealthBar.size.x
	
	# player stuff
	$Health/You/Current.size.x = $Health/You.size.x
	$Health/You/LastHit.text = ""
	playerDamage = Storage.get_attack()
	player["maxHp"] = Storage.get_defense()
	player["hp"] = player["maxHp"]

	# quest reward
	questReward = quest.questMaterial
	partSprite.set_part(questReward)
	partSprite.visible = false
	
	# start
	minigameActive = true
	spawn_note()
	pass

func end_minigame():
	minigameActive = false
	for bar in bars.get_children():
		bar.queue_free()
	for col in gameCols:
		col.reset()
	Stats.accuracy.x += accuracy
	Stats.accuracy.y += totalNotes

func update_accuracy(quality):
	if !minigameActive:
		return
	totalNotes+=1
	match quality:
		"good": accuracy +=1
		"ok": accuracy +=.5

func hit_player(quality):
	update_accuracy(quality)
	var damage = enemyDamage
	match quality:
		"good":
			$Health/You/LastHit.text = "PERFECT BLOCK"
			return
		"ok":
			damage /= 2
			$Health/You/LastHit.text = str(damage) + " BLOCK"
		"miss":
			$Health/You/LastHit.text = str(damage)
		"wrong":
			return
	
		
	player["hp"] -= damage
	
	$Health/You/Current.size.x = max(0,$Health/You.size.x * player["hp"]/player["maxHp"])
	
	if player["hp"] <= 0:
		end_minigame()
		timer.stop()
		Stats.deaths += 1
		await get_tree().create_timer(2).timeout
		visible = false
		emit_signal("player_death")

func hit_enemy(quality):
	update_accuracy(quality)
	var damage = playerDamage
	match quality:
		"good":
			damage *= 1.5
			$Health/Enemy/LastHit.text = str(damage) + " CRIT"
		"ok":
			$Health/Enemy/LastHit.text = str(damage)
		"miss":
			return
		"wrong":
			return

	enemy.stats.hp -= damage
	enemy.hit()
	
	enemyHealth.size.x = max(0,enemyHealthBar.size.x * enemy.stats.hp/enemy.stats.maxHp)
	
	if enemy.stats.hp <= 0:
		end_minigame()
		killEnemy = true
		timer.stop()

func spawn_note():
	var spawnedNotes :Array
	var action = enemy.stats.pick_action()
	
	if Settings.noteMax == 1:
		match action:
			"double block":
				action = "block"
			"attack block":
				if randi_range(0,1) == 0:
					action = "attack"
				else:
					action = "block"
			"attack double block":
				if randi_range(0,1) == 0:
					action = "attack"
				else:
					action = "block"
	elif Settings.noteMax == 2 and action == "attack double block":
			if randi_range(0,1) == 0:
				action = "attack block"
			else:
				action = "double block"
	
	match action:
		"attack":
			if randf()<.5:
				spawnedNotes.push_back(gameCols[1].spawn_note())
			else:
				spawnedNotes.push_back(gameCols[2].spawn_note())
		"block":
			if randf()<.5:
				spawnedNotes.push_back(gameCols[0].spawn_note())
			else:
				spawnedNotes.push_back(gameCols[3].spawn_note())
		"double block":
			spawnedNotes.push_back(gameCols[0].spawn_note())
			spawnedNotes.push_back(gameCols[3].spawn_note())
		"attack block":
			if randf()<.5:
				spawnedNotes.push_back(gameCols[0].spawn_note())
			else:
				spawnedNotes.push_back(gameCols[3].spawn_note())
			if randf()<.5:
				spawnedNotes.push_back(gameCols[1].spawn_note())
			else:
				spawnedNotes.push_back(gameCols[2].spawn_note())
		"attack double block":
			if randf()<.5:
				spawnedNotes.push_back(gameCols[1].spawn_note())
			else:
				spawnedNotes.push_back(gameCols[2].spawn_note())
			spawnedNotes.push_back(gameCols[0].spawn_note())
			spawnedNotes.push_back(gameCols[3].spawn_note())
	
	if Settings.noteSyncBar == "all" or (Settings.noteSyncBar == "multi" and spawnedNotes.size()>1):
		var bar = syncBar.instantiate()
		bar.position = Vector2.ZERO
		bar.speed = noteSpeed
		bars.add_child(bar)
		bar.notes = spawnedNotes
	
	timer.start(randf_range(enemy.stats.noteDelayMin,enemy.stats.noteDelayMax))

func _on_timer_timeout():
	if killEnemy:
		if enemy.stats.type == "Dragon":
			emit_signal("win")
			timer.stop()
			return
		timer.stop()
		Storage.add_part(questReward, 1)
		emit_signal("combat_done")
	else:
		spawn_note()


func _on_button_pressed():
	end_minigame()
	visible = false
