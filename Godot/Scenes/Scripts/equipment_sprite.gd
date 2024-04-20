extends Sprite2D

var equipment:Equipment
var parts:Array

func _ready():
	parts = $Parts.get_children()

func set_equip(equip):
	$Parts.visible = true
	equipment = equip
	if equipment == null:
		visible = false 
		return
		
	visible = true 
	
	for i in range(0,parts.size()):
		parts[i].z_index = 0
		if i < equipment.parts.size() and equipment.parts[i].rarity >= 0:
			parts[i].visible = true
			parts[i].self_modulate = equipment.parts[i].get_color()
		else:
			parts[i].visible = false
	
	var f
	match(equipment.type):
		"dagger": 
			f = 0
			parts[1].z_index = 2
		"sword": 
			f = 1
			parts[2].z_index = 2
		"greatsword": 
			f = 2
			parts[3].z_index = 2
		"light armor": 
			f = 3
			parts[0].z_index = 1
			parts[2].z_index = 2
		"med armor": 
			f = 4
			parts[0].z_index = 1
			parts[3].z_index = 2
			parts[4].z_index = 2
		"heavy armor": 
			f = 5
			parts[0].z_index = 1
			parts[4].z_index = 2
			parts[5].z_index = 2
	f=f*8+1
	frame = f+6
	
	for i in range(0,parts.size()):
		parts[i].frame = f+i
	

func set_ghost(type):
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
	
	frame = f*8
