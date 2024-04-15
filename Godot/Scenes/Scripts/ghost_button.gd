extends Button
@export var type: String

func _ready():
	if type != "":
		set_type(type)
		
func set_type(t):
	type = t
	
	match(t):
		"m": $Sprite.frame = 0
		"f": $Sprite.frame = 1
		"s": $Sprite.frame = 2
		"dagger": $Sprite.frame = 3
		"sword": $Sprite.frame = 4
		"greatsword": $Sprite.frame = 5
		"light armor": $Sprite.frame = 6
		"med armor": $Sprite.frame = 7
		"heavy armor": $Sprite.frame = 8
