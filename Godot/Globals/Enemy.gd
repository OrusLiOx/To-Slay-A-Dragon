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
	match(type):
		"Goblin": # 5, 10
			attack = 5
			maxHp = 25
			noteDelayMin = .7
			noteDelayMax = .7
			
			weight["attack"] = .5
			weight["block"] = .5
		"Serpent": # 10, 10
			attack = 10
			maxHp = 150
			noteDelayMin = .5
			noteDelayMax = 1
			
			weight["attack"] = .8
			weight["block"] = .2
		"Fairy": # 10, 25
			attack = 5
			maxHp = 50
			noteDelayMin = .5
			noteDelayMax = .5
			
			weight["attack"] = .3
			weight["block"] = .4
			weight["double block"] = .3
		
		
		"Gold Beetle": # 20, 45
			attack = 15
			maxHp = 250
			noteDelayMin = .4
			noteDelayMax = .6
			
			weight["attack"] = .5
			weight["block"] = .3
			weight["double block"] = .2
		"Magma Lizard": # 30, 50
			attack = 15
			maxHp = 300
			noteDelayMin = .5
			noteDelayMax = .7
			
			weight["attack"] = .3
			weight["block"] = .4
			weight["attack block"] = .2
		"Fire Spirit": # 30, 60
			attack = 10
			maxHp = 30
			noteDelayMin = .3
			noteDelayMax = .5
			
			weight["block"] = .6
			weight["attack block"] = .05
			weight["double block"] = .35
			
		"Animated Armor": # 40, 80
			attack = 20
			maxHp = 500
			noteDelayMin = .3
			noteDelayMax = 1
			
			weight["attack"] = .3
			weight["block"] = .3
			weight["double block"] = .2
			weight["attack block"] = .2
		"Wyvern": # 50, 85
			attack = 15
			maxHp = 650
			noteDelayMin = .3
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
		"Mimic", "Chest?": # 50, 95
			attack = 20
			maxHp = 450
			noteDelayMin = .3
			noteDelayMax = .6
				
			weight["block"] = .3
			weight["double block"] = .2
			weight["attack block"] = .3
			weight["attack double block"] = .2
		
		"Dragon": # 60, 105
			attack = 30
			maxHp = 900
			noteDelayMin = .3
			noteDelayMax = .7
			
			weight["block"] = .2
			weight["double block"] = .2
			weight["attack block"] = .3
			weight["attack double block"] = .3
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
