class_name Enemy
var type : String
var attack : float
var defense : float
var hp : float

func _init(t :String):
	set_enemy(t)

func set_enemy(t : String):
	type = t
	match(type):
		"Slime":
			attack = 10
			defense = 10
		"Goblin":
			attack = 10
			defense = 10
		"Snake":
			attack = 10
			defense = 10
	attack = 10
	defense = 0
	
	heal()

func heal():
	hp = max(defense*10,10)
