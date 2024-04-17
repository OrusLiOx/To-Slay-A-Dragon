extends Node2D

var questData:Dictionary
var quests
var combat

signal toCamp()
# Called when the node enters the scene tree for the first time.
func _ready():
	combat = $Combat
	
	questData["main"]=$QuestName
	questData["material"] = $QuestName/MaterialLabel
	questData["material sprite"] = $QuestName/PartSprite
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
	combat.visible = true
	$Switch.disable = true
	for q in quests:
		q.disabled = true
	questData["main"].visible = false
	combat.start(quest)

func finish_quest():
	combat.visible = false
	$Switch.disable = false
	for quest in quests:
		quest.disabled = true

func show_quest_data(quest):
	if combat.visible:
		return
	var part = Part.new(quest.questMaterial[0], int(quest.questMaterial[1]))
	questData["main"].position = quest.dataDisplayPosition
	questData["main"].text = quest.name
	questData["material"].text = part.get_name()
	questData["material sprite"].set_part(part)
	questData["enemy name"].text = quest.questEnemy
	#questData["enemy stats"].text
	questData["your stats"].text = str(Storage.equipment[Storage.curWeapon].value) + "\n" 
	questData["your stats"].text += str(Storage.equipment[Storage.curArmor].value)
	questData["main"].visible = true
	pass
	
func hide_quest_data():
	questData["main"].visible = false

func _on_switch_button_down():
	emit_signal("toCamp")
	pass # Replace with function body.
