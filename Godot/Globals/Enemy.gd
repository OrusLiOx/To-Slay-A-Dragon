class_name Enemy
var type : String
var attack : float
var defense : float
var hp : float
var maxHp : float

func _init(t :String):
	set_enemy(t)

func set_enemy(t : String):
	type = t
	match(type):
		"Slime":
			attack = 5
			defense = 5
			maxHp = 10
		"Goblin":
			attack = 10
			defense = 10
			maxHp = 10
		"Snake":
			attack = 5
			defense = 5
			maxHp = 10
	
	heal()

func heal():
	hp = maxHp
