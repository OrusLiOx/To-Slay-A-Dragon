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
		"Goblin":
			attack = 10
			defense = 5
			maxHp = 10
			noteDelayMin = .7
			noteDelayMax = .7
			
			weight["attack"] = .5
			weight["block"] = .5
		"Serpent":
			attack = 10
			defense = 10
			maxHp = 10
			noteDelayMin = .5
			noteDelayMax = 1
			
			weight["attack"] = .4
			weight["block"] = .5
			weight["attack block"] = .1
		"Fairy":
			attack = 15
			defense = 10
			maxHp = 10
			noteDelayMin = .5
			noteDelayMax = .5
			
			weight["attack"] = .5
			weight["block"] = .4
			weight["double block"] = .1
		
		"Gold Beetle":
			attack = 50
			defense = 30
			maxHp = 20
			noteDelayMin = .5
			noteDelayMax = 1
			
			weight["attack"] = .5
			weight["block"] = .3
			weight["double block"] = .2
		"Magma Lizard":
			attack = 45
			defense = 50
			maxHp = 20
			noteDelayMin = .7
			noteDelayMax = .7
			
			weight["attack"] = .4
			weight["block"] = .4
			weight["attack block"] = .2
		"Fire Spirit":
			attack = 70
			defense = 40
			maxHp = 20
			noteDelayMin = .5
			noteDelayMax = .5
			
			weight["block"] = .5
			weight["attack block"] = .5
			
		"Animated Armor":
			attack = 90
			defense = 80
			maxHp = 30
			noteDelayMin = .5
			noteDelayMax = 1
			
			weight["attack"] = .3
			weight["block"] = .3
			weight["double block"] = .2
			weight["attack block"] = .2
		"Wyvern":
			attack = 80
			defense = 95
			maxHp = 30
			noteDelayMin = .5
			noteDelayMax = .5
			
			weight["attack"] = .2
			weight["block"] = .3
			weight["double block"] = .2
			weight["attack block"] = .2
			weight["attack double block"] = .1
		"Chest":
			attack = 0
			defense = 0
			maxHp = 1
			noteDelayMin = .7
			noteDelayMax = .7
			weight["attack"] = 1
		"Mimic":
			attack = 70
			defense = 70
			maxHp = 30
			noteDelayMin = .7
			noteDelayMax = .7
				
			weight["attack"] = .4
			weight["block"] = .4
			weight["double block"] = .1
			weight["attack block"] = .1
		
		"Dragon":
			attack = 110
			defense = 110
			maxHp = 50
			noteDelayMin = .5
			noteDelayMax = .5
			
			weight["double block"] = .3
			weight["attack block"] = .4
			weight["attack double block"] = .3
	maxHp = 50
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
