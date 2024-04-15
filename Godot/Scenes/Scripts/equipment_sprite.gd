extends Sprite2D

var equipment:Equipment

func set_equip(equip):
	equipment = equip
	if equipment == null:
		self_modulate.a = 0
		return
	var f
	match(equipment.type):
		"dagger": f = 0
		"sword": f = 1
		"greatsword": f = 2
		"light armor": f = 3
		"med armor": f = 4
		"heavy armor": f = 5
	
	frame = f
	self_modulate = equipment.parts[0].get_color()
