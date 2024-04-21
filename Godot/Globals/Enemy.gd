class_name Enemy
var type : String
var attack : float
var defense : float
var hp : float
var maxHp : float
var noteSpeed : float
var noteDelayMax : float
var noteDelayMin : float

func _init(t :String):
	set_enemy(t)

func set_enemy(t : String):
	type = t
	match(type):
		"Goblin":
			attack = 10
			defense = 5
			maxHp = 10
			noteSpeed = 300
			noteDelayMin = .7
			noteDelayMax = .7
		"Serpent":
			attack = 10
			defense = 10
			maxHp = 10
			noteSpeed = 300
			noteDelayMin = .5
			noteDelayMax = 1
		"Fairy":
			attack = 15
			defense = 15
			maxHp = 10
			noteSpeed = 300
			noteDelayMin = .25
			noteDelayMax = .5
		
		
		"Gold Beetle":
			attack = 50
			defense = 30
			maxHp = 20
			noteSpeed = 400
			noteDelayMin = .7
			noteDelayMax = .7
		"Magma Lizard":
			attack = 45
			defense = 50
			maxHp = 20
			noteSpeed = 400
			noteDelayMin = .25
			noteDelayMax = .5
		"Fire Fox":
			attack = 70
			defense = 40
			maxHp = 20
			noteSpeed = 400
			noteDelayMin = .25
			noteDelayMax = .25
			
		"Animated Armor":
			attack = 90
			defense = 80
			maxHp = 30
			noteSpeed = 600
			noteDelayMin = .25
			noteDelayMax = .7
		"Wyvern":
			attack = 80
			defense = 95
			maxHp = 30
			noteSpeed = 600
			noteDelayMin = .25
			noteDelayMax = 1
		"Chest?":
			if randf()<.1:
				type = "Chest"
				attack = 0
				defense = 0
				maxHp = 1
				noteSpeed = 300
				noteDelayMin = .7
				noteDelayMax = .7
			else:
				type = "Mimic"
				attack = 70
				defense = 70
				maxHp = 30
				noteSpeed = 600
				noteDelayMin = .25
				noteDelayMax = .5
		
		"Dragon":
			attack = 110
			defense = 110
			maxHp = 50
			noteSpeed = 700
			noteDelayMin = .25
			noteDelayMax = 1
	maxHp = 50
	heal()

func heal():
	hp = maxHp
