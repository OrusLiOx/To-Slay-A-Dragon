extends Node2D

var questData:Dictionary
var quests
var combat

signal toCamp()
signal death()
signal time()
# Called when the node enters the scene tree for the first time.
func _ready():
	combat = $Combat
	
	questData["main"]=$QuestName
	questData["material"] = $QuestName/MaterialLabel
	questData["material sprite"] = $QuestName/PartSprite
	questData["material sprite"].disabled = true
	questData["enemy name"] = $QuestName/Node2D/Enemy
	questData["enemy stats"] = $QuestName/Node2D/Enemy/EnemyData
	questData["your stats"] = $QuestName/Node2D/You/YourData
	quests = $Quests.get_children()
	
	for quest in quests:
		quest.mouse_entered.connect(show_quest_data.bind(quest))
		quest.mouse_exited.connect(hide_quest_data)
		quest.button_down.connect(start_quest.bind(quest))
	pass # Replace with function body.

func start_quest(quest):
	emit_signal("time")
	$Clock.turn()
	combat.visible = true
	$Switch.disabled = true
	for q in quests:
		q.disabled = true
	questData["main"].visible = false
	combat.start(quest)

func finish_quest():
	combat.visible = false
	$Switch.disabled = false
	for quest in quests:
		quest.disabled = false

func show_quest_data(quest):
	if combat.visible:
		return
	
	var x = quest.position.x
	if x < 0:
		x += 57
	else:
		x -= 463
	var y = min(max(quest.position.y-125,-530),182)
	questData["main"].position = Vector2(x,y)
	questData["main"].text = quest.name
	
	if quest.enemy == "Dragon":
		questData["material"].text = "The final battle"
		questData["material sprite"].visible = false
	else:
		questData["material"].text = quest.questMaterial.get_name() + "\nValue: "+ str(quest.questMaterial.get_value())
		questData["material sprite"].set_part(quest.questMaterial)
		questData["material sprite"].visible = true
	
	questData["enemy name"].text = quest.enemy
	questData["enemy stats"].text = str(quest.questEnemy.attack) + "\n" + str(quest.questEnemy.defense)
	
	questData["your stats"].text = str(Storage.get_attack()) + "\n" 
	questData["your stats"].text += str(Storage.get_defense())
	questData["main"].visible = true
	pass
	
func hide_quest_data():
	questData["main"].visible = false

func _on_switch_button_down():
	emit_signal("toCamp")
	pass # Replace with function body.

func _on_combat_combat_done():
	finish_quest()
	pass # Replace with function body.

func _on_combat_player_death():
	emit_signal("death")
	$Clock.turn(2)
	combat.visible = false
	pass # Replace with function body.

func _on_combat_win():
	combat.visible = false
	$Win.visible = true
	$Win/Stats.text = "You took " + str(Stats.totaltime/4.0) + " days\nto kill the dragon\n"
	$Win/Stats.text += "\nTotal Combats: " + str(Stats.combats)
	$Win/Stats.text += "\nDeaths: " + str(Stats.deaths)
	$Win/Stats.text += "\nWin Rate: " + str((Stats.combats-Stats.deaths)/Stats.combats)
	
	pass # Replace with function body.

func _on_button_mouse_entered():
	if Stats.totaltime == 4:
		$Button/ColorRect/Label.text = "1 day\nhas passed"
	else:
		$Button/ColorRect/Label.text = str(Stats.totaltime/4.0)+" days\nhave passed"
	$Button/ColorRect.visible = true
	pass # Replace with function body.

func _on_button_mouse_exited():
	$Button/ColorRect.visible = false
	pass # Replace with function body.

func _on_clock_done():
	if combat.visible:
		return
	$Switch.disabled = false
	for quest in quests:
		quest.disabled = false
	pass # Replace with function body.
