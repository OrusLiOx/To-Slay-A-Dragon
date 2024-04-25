extends Node2D

@export var noteScene : PackedScene
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
var rewardQuantity

# note stuff
var goodNote :Array
var okNote :Array
var badNote :Array
var notes

signal combat_done()
signal player_death()
signal win()

func _ready():
	timer = $Timer
	enemy = $EnemyScreen/Enemy
	partSprite = $EnemyScreen/PartSprite
	enemyHealthBar = $EnemyScreen/Health
	enemyHealth = $EnemyScreen/Health/Current
	gameCols = $Minigame.get_children()
	pass # Replace with function body.

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
	# generic
	accuracy =0
	totalNotes = 0
	Stats.combats +=1
	
	killEnemy = false
	noteSpeed = enemy.stats.noteSpeed
	
	for col in gameCols:
		col.speed = noteSpeed
		col.reset()
	
	# Enemy stuff
	$EnemyScreen/Health/Name.text = quest.enemy
	enemy.set_enemy(quest.questEnemy)
	enemy.stats.heal()
	enemy.modulate.a = 1
	
	enemyHealth.size.x=enemyHealthBar.size.x
	$EnemyScreen/Health/LastHit.text = ""
	enemyDamage = get_damage(enemy.stats.attack, Storage.get_defense())
	enemyHealthBar.modulate.a = 1
	enemyHealth.size.x = enemyHealthBar.size.x
	
	# player stuff
	$EnemyScreen/You/Current.size.x = $EnemyScreen/You.size.x
	$EnemyScreen/You/LastHit.text = ""
	$EnemyScreen/Reward.text = ""
	playerDamage = get_damage(Storage.get_attack(), enemy.stats.defense)
	player["maxHp"] = 50
	player["hp"] = player["maxHp"]

	# quest reward
	questReward = quest.questMaterial
	partSprite.set_part(questReward)
	
	# no drop if dragon
	if quest.enemy == "Dragon":
		partSprite.modulate.a = 0
	
	# start
	minigameActive = true
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
	var damage = max(attack * defense/200,1)
	
	return max(int(attack/defense*1000)/1000.0, .001)

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
