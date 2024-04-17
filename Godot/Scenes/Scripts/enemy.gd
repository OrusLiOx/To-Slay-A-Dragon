extends Sprite2D
var type : String
var attack : float
var defense : float
var hp : float

func set_enemy(t : String ):
	type = t
	match(type):
		"slime":
			attack = 10
			defense = 10
		"goblin":
			attack = 10
			defense = 10
		"snake":
			attack = 10
			defense = 10
	
	heal()

func heal():
	hp = defense
