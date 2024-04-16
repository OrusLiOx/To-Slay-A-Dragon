extends Sprite2D

var equipment:Equipment
var parts:Array

func _ready():
	parts = $Parts.get_children()

func set_equip(equip):
	$Parts.visible = true
	self.self_modulate.a = 0
	equipment = equip
	if equipment == null:
		$Parts.visible = false 
		return
	var f
	match(equipment.type):
		"dagger": f = 0
		"sword": f = 1
		"greatsword": f = 2
		"light armor": f = 3
		"med armor": f = 4
		"heavy armor": f = 5
	f=f*7+1
	for i in range(0,parts.size()):
		parts[i].frame = f+i
		if i < equipment.parts.size():
			parts[i].visible = true
			parts[i].self_modulate = equipment.parts[i].get_color()
		else:
			parts[i].visible = false

func set_ghost(type):
	self.self_modulate.a = 1
	equipment = null
	$Parts.visible = false
	var f
	match(type):
		"dagger": f = 0
		"sword": f = 1
		"greatsword": f = 2
		"light armor": f = 3
		"med armor": f = 4
		"heavy armor": f = 5
	
	frame = f*7
