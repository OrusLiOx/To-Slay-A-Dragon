extends Node2D

@export var noteScene : PackedScene
var timer : Timer
var enemy
var noteSpeed
var gameCols

var goodNote :Array
var okNote :Array
var badNote :Array
var notes

var minigameActive
var killEnemy
var partSprite
var enemyHealth
var enemyHealthBar

var accuracy
var totalNotes

var enemyDamage
var playerDamage

var questReward
var rewardQuantity

var player : Dictionary

var dir:Dictionary

signal combat_done()
signal player_death()
signal win()

# Called when the node enters the scene tree for the first time.
func _ready():
	timer = $Timer
	enemy = $EnemyScreen/Enemy
	partSprite = $EnemyScreen/PartSprite
	enemyHealthBar = $EnemyScreen/Health
	enemyHealth = $EnemyScreen/Health/Current
	gameCols = $Minigame.get_children()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if killEnemy:
		if enemy.modulate.a  > 0:
			enemy.modulate.a -= 2*delta
			enemyHealthBar.modulate.a -= 2*delta
		else:
			if partSprite.visible == false:
				timer.start(2)
			partSprite.visible = true
	pass

func start(quest):
	accuracy =0
	totalNotes = 0
	
	Stats.combats +=1
	if quest.enemy == "Dragon":
		partSprite.modulate.a = 0
	$EnemyScreen/Health/Name.text = quest.enemy
	enemyHealth.size.x=enemyHealthBar.size.x
	$EnemyScreen/You/Current.size.x = $EnemyScreen/You.size.x
	$EnemyScreen/Health/LastHit.text = ""
	$EnemyScreen/You/LastHit.text = ""
	$EnemyScreen/Reward.text = ""
	
	# set display stuff
	player["attack"] = Storage.get_attack()
	player["defense"] = Storage.get_defense()
	player["maxHp"] = 50
	player["hp"] = player["maxHp"]
	
	questReward = quest.questMaterial
	rewardQuantity = 0
	partSprite.visible = false
	partSprite.set_part(questReward)
	enemy.set_enemy(quest.questEnemy)
	enemy.stats.heal()
	enemy.modulate.a = 1
	enemyHealthBar.modulate.a = 1
	enemyHealth.size.x = enemyHealthBar.size.x
	minigameActive = true
	killEnemy = false
	
	noteSpeed =enemy.stats.noteSpeed
	for col in gameCols:
		col.speed = noteSpeed
		col.reset()
	
	playerDamage = get_damage(player["attack"], enemy.stats.defense)
	enemyDamage = get_damage(enemy.stats.attack, player["defense"])
	spawn_note()
	pass

func end_minigame():
	minigameActive = false
	for col in gameCols:
		col.reset()
	Stats.accuracy.x += accuracy
	Stats.accuracy.y += totalNotes

func update_accuracy(quality):
	totalNotes+=1
	match quality:
		"good": accuracy +=1
		"ok": accuracy +=.5

func hit_player(quality):
	update_accuracy(quality)
	var damage = enemyDamage
	match quality:
		"good":
			$EnemyScreen/You/LastHit.text = "PERFECT BLOCK"
			return
		"ok":
			damage /= 4
			$EnemyScreen/You/LastHit.text = str(damage) + " BLOCK"
		"miss":
			$EnemyScreen/You/LastHit.text = str(damage)
		"wrong":
			return
	
	player["hp"] -= damage
	
	$EnemyScreen/You/Current.size.x = max(0,$EnemyScreen/You.size.x * player["hp"]/player["maxHp"])
	
	if player["hp"] <= 0:
		end_minigame()
		Stats.deaths += 1
		emit_signal("player_death")
		timer.stop()
	pass

func hit_enemy(quality):
	update_accuracy(quality)
	var damage = playerDamage
	match quality:
		"good":
			damage *= 2
			$EnemyScreen/Health/LastHit.text = str(damage) + " CRITICAL"
		"ok":
			$EnemyScreen/Health/LastHit.text = str(damage)
		"miss":
			return
		"wrong":
			return

	enemy.stats.hp -= damage
	
	enemyHealth.size.x = max(0,enemyHealthBar.size.x * enemy.stats.hp/enemy.stats.maxHp)
	
	if enemy.stats.hp <= 0:
		end_minigame()
		killEnemy = true
		rewardQuantity = 1
		var bonus = accuracy/totalNotes
		if bonus == 1:
			bonus = 2
		while bonus >= 1:
			rewardQuantity += 1
			bonus -= 1
			
		if randf() <= bonus:
			rewardQuantity +=1
		
		$EnemyScreen/Reward.text = "+"+str(rewardQuantity)
		if rewardQuantity > 1:
			$EnemyScreen/Reward.text +=  " ("+str(rewardQuantity-1)+" bonus)"
		timer.stop()
	pass

func get_damage(attack, defense):
	return max(attack * defense/180,1)
	var damage = attack-defense
	if damage > 0:
		return damage
	else:
		return int(attack/defense*1000)/1000.0

func spawn_note():
	match enemy.stats.pick_action():
		"attack":
			if randf()<.5:
				gameCols[1].spawn_note()
			else:
				gameCols[2].spawn_note()
		"block":
			if randf()<.5:
				gameCols[0].spawn_note()
			else:
				gameCols[3].spawn_note()
		"double block":
			gameCols[0].spawn_note()
			gameCols[3].spawn_note()
		"attack block":
			if randf()<.5:
				gameCols[0].spawn_note()
			else:
				gameCols[3].spawn_note()
			if randf()<.5:
				gameCols[1].spawn_note()
			else:
				gameCols[2].spawn_note()
		"attack double block":
			if randf()<.5:
				gameCols[1].spawn_note()
			else:
				gameCols[2].spawn_note()
			gameCols[0].spawn_note()
			gameCols[3].spawn_note()
			
	timer.start(randf_range(enemy.stats.noteDelayMin,enemy.stats.noteDelayMax))

func _on_timer_timeout():
	if killEnemy:
		if enemy.stats.type == "Dragon":
			emit_signal("win")
			timer.stop()
			return
		timer.stop()
		Storage.add_part(questReward, rewardQuantity)
		emit_signal("combat_done")
	else:
		spawn_note()
	pass # Replace with function body.
