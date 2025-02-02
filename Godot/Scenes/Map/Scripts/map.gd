extends Node2D

var questData:Dictionary
var quests
var combat

signal toCamp()
signal death()
signal time()

# Called when the node enters the scene tree for the first time.
func _ready():
	$Win.visible = false
	
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
		quest.pressed.connect(start_quest.bind(quest))

func start_quest(quest):
	emit_signal("time")
	combat.visible = true
	questData["main"].visible = false
	
	combat.start(quest)

func finish_quest():
	combat.visible = false

func show_quest_data(quest):
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
	questData["enemy stats"].text = str(quest.questEnemy.attack) + "\n" + str(quest.questEnemy.maxHp)
	
	questData["your stats"].text = str(Storage.get_attack()) + "\n" 
	questData["your stats"].text += str(Storage.get_defense())
	questData["main"].visible = true
	
func hide_quest_data():
	questData["main"].visible = false

func _on_switch_pressed():
	visible = false

func _on_combat_combat_done():
	finish_quest()

func _on_combat_player_death():
	emit_signal("death")

func _on_combat_win():
	combat.visible = false
	$Win.visible = true
	$Win/Stats.text = Stats.stats_to_string()

func _on_visibility_changed():
	Audio.play("PageFlip")
