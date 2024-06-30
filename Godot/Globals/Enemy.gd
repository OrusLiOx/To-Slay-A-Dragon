class_name Enemy
var type : String
var attack : float
var defense : float
var hp : float
var maxHp : float
var noteDelayMax : float
var noteDelayMin : float
var weight:Dictionary

func _init(t :String):
	set_enemy(t)

func set_enemy(t : String):
	type = t
	if type == "Chest?":
		if randf()<.1:
			type = "Chest"
		else:
			type = "Mimic"
	match(type):
		"Goblin": # 5, 10
			attack = 2
			maxHp = 25
			noteDelayMin = .7
			noteDelayMax = .7
			
			weight["attack"] = .5
			weight["block"] = .5
		"Serpent": # 10, 10
			attack = 5
			maxHp = 200
			noteDelayMin = .5
			noteDelayMax = 1
			
			weight["attack"] = .8
			weight["block"] = .2
		"Fairy": # 10, 20
			attack = 5
			maxHp = 100
			noteDelayMin = .5
			noteDelayMax = .5
			
			weight["attack"] = .3
			weight["block"] = .4
			weight["double block"] = .3
		
		
		"Gold Beetle": # 15, 30
			attack = 10
			maxHp = 200
			noteDelayMin = .5
			noteDelayMax = 1
			
			weight["attack"] = .5
			weight["block"] = .3
			weight["double block"] = .2
		"Magma Lizard": # 25, 30
			attack = 15
			maxHp = 300
			noteDelayMin = .7
			noteDelayMax = .7
			
			weight["attack"] = .3
			weight["block"] = .4
			weight["attack block"] = .3
		"Fire Spirit": # 25, 40
			attack = 10
			maxHp = 25
			noteDelayMin = .5
			noteDelayMax = .5
			
			weight["block"] = .6
			weight["attack block"] = .05
			weight["double block"] = .35
			
		"Animated Armor": # 30, 50
			attack = 20
			maxHp = 250
			noteDelayMin = .5
			noteDelayMax = 1
			
			weight["attack"] = .3
			weight["block"] = .3
			weight["double block"] = .2
			weight["attack block"] = .2
		"Wyvern": # 40, 50
			attack = 15
			maxHp = 350
			noteDelayMin = .5
			noteDelayMax = .7
			
			weight["attack"] = .2
			weight["block"] = .2
			weight["double block"] = .3
			weight["attack block"] = .3
		"Chest":
			attack = 0
			maxHp = 1
			noteDelayMin = .7
			noteDelayMax = .7
			weight["attack"] = 1
		"Mimic": # 40, 60
			attack = 20
			maxHp = 300
			noteDelayMin = .3
			noteDelayMax = 1
				
			weight["block"] = .3
			weight["double block"] = .2
			weight["attack block"] = .3
			weight["attack double block"] = .2
		
		"Dragon": # 45, 70
			attack = 25
			maxHp = 500
			noteDelayMin = .3
			noteDelayMax = .7
			
			weight["attack"] = .2
			weight["block"] = .2
			weight["double block"] = .2
			weight["attack block"] = .2
			weight["attack double block"] = .2
	heal()

func pick_action():
	var r = randf()
	var cur = 0
	for key in weight.keys():
		cur+=weight[key]
		if r <= cur:
			return key
	pass

func heal():
	hp = maxHp
