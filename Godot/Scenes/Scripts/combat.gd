extends Node2D

@export var noteScene : PackedScene
var timer : Timer
var enemy
var noteSpeed

var goodNote :Array
var okNote :Array
var badNote :Array
var notes

var minigameActive
var killEnemy
var partSprite
var enemyHealth
var enemyHealthBar

var questReward
var rewardQuantity

var player : Dictionary

var dir:Dictionary

signal combat_done()
signal player_death()
signal win()

# Called when the node enters the scene tree for the first time.
func _ready():
	notes = $Minigame/Notes
	timer = $Timer
	enemy = $EnemyScreen/Enemy
	partSprite = $EnemyScreen/PartSprite
	enemyHealthBar = $EnemyScreen/Health
	enemyHealth = $EnemyScreen/Health/Current
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
			enemyHealthBar.modulate.a -= 2*delta
		else:
			if partSprite.visible == false:
				timer.start(2)
			partSprite.visible = true
	pass

func start(quest):
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
	for note in notes.get_children():
		note.queue_free()
	
	questReward = quest.questMaterial
	rewardQuantity = 0
	partSprite.visible = false
	partSprite.set_part(questReward)
	enemy.set_enemy(quest.questEnemy)
	enemy.stats.heal()
	enemy.modulate.a = 1
	enemyHealthBar.modulate.a = 1
	enemyHealth.size.x = enemyHealthBar.size.x
	goodNote.clear()
	okNote.clear()
	badNote.clear()
	minigameActive = true
	killEnemy = false
	
	noteSpeed =enemy.stats.noteSpeed #min(2000,max(enemy.stats.noteSpeed, (enemy.stats.attack-player["defense"]*1.1)*100+enemy.stats.noteSpeed))
	spawn_note()
	pass

func end_minigame():
	minigameActive = false
	for note in notes.get_children():
		note.queue_free()

func check(inp):
	if !goodNote.is_empty():
		if goodNote.front().dir == dir[inp]:
			hit_enemy(.5)
		else:
			hit_player()
		goodNote.front().queue_free()
		goodNote.pop_front()
		okNote.pop_front()
		badNote.pop_front()	
	elif !okNote.is_empty():
		if okNote.front().dir == dir[inp]:
			hit_enemy(0)
		else:
			hit_player()
		okNote.front().queue_free()
		okNote.pop_front()
		badNote.pop_front()
	elif !badNote.is_empty():
		hit_player()
		badNote.front().queue_free()
		badNote.pop_front()
	else:
		hit_player()
		
func hit_player():
	var damage = get_damage(enemy.stats.attack,player["defense"])
	player["hp"] -= damage
	$EnemyScreen/Health/LastHit.text = ""
	$EnemyScreen/You/LastHit.text = str(damage)
	
	$EnemyScreen/You/Current.size.x = max(0,$EnemyScreen/You.size.x * player["hp"]/player["maxHp"])
	
	if player["hp"] <= 0:
		end_minigame()
		Stats.deaths += 1
		emit_signal("player_death")
		timer.stop()
	pass

func hit_enemy(crit:float = 0):
	var damage = get_damage(player["attack"],enemy.stats.defense)
	$EnemyScreen/You/LastHit.text = ""
	enemy.hit()
	if randf()<crit:
		damage = damage*2
		enemy.stats.hp -= damage
		$EnemyScreen/Health/LastHit.text = str(damage) + " CRIT!"
	else:
		enemy.stats.hp -= damage
		$EnemyScreen/Health/LastHit.text = str(damage)
	
	enemyHealth.size.x = max(0,enemyHealthBar.size.x * enemy.stats.hp/enemy.stats.maxHp)
	
	if enemy.stats.hp <= 0:
		end_minigame()
		killEnemy = true
		rewardQuantity = 1
		var bonus = (player["hp"]/player["maxHp"])/2 + (abs(enemy.stats.hp)/enemy.stats.maxHp)/2
		while bonus >= 1:
			rewardQuantity += 1
			bonus -= 1
			
		if randf() < bonus:
			rewardQuantity +=1
		
		$EnemyScreen/Reward.text = "+"+str(rewardQuantity)
		if rewardQuantity > 1:
			$EnemyScreen/Reward.text +=  " ("+str(rewardQuantity-1)+" bonus)"
		timer.stop()
	pass

func get_damage(attack, defense):
	var damage = attack-defense
	if damage > 0:
		return damage
	else:
		return int(attack/defense*1000)/1000.0

func spawn_note():
	var n = noteScene.instantiate()
	notes.add_child(n)
	n.speed = noteSpeed
	n.position = Vector2(800,60)
	timer.start(randf_range(enemy.stats.noteDelayMin/(noteSpeed/enemy.stats.noteSpeed),enemy.stats.noteDelayMax/(noteSpeed/enemy.stats.noteSpeed)))

# detect notes
func _on_good_area_entered(area):
	if area.is_in_group("Note"):
		goodNote.push_back(area)
	pass # Replace with function body.

func _on_good_area_exited(area):
	if area.is_in_group("Note"):
		goodNote.pop_front()
	pass # Replace with function body.

func _on_ok_area_entered(area):
	if area.is_in_group("Note"):
		okNote.push_back(area)
	pass # Replace with function body.

func _on_ok_area_exited(area):
	if area.is_in_group("Note"):
		okNote.pop_front()
	pass # Replace with function body.

func _on_bad_area_entered(area):
	if area.is_in_group("Note"):
		badNote.push_back(area)
	pass #

func _on_bad_area_exited(area):
	if area.is_in_group("Note"):
		badNote.pop_front()
	pass # Replace with function body.

func _on_kill_area_entered(area):
	if area.is_in_group("Note"):
		hit_player()
	area.queue_free()
	pass 

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

