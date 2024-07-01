extends Node

var curWeapon : int
var curArmor : int

var equipment : Array

var parts : Dictionary
var food : Array

# Called when the node enters the scene tree for the first time.
func _ready():	
	parts = { 
		's' : [],
		'f' : [],
		'm' : []
	}
	for key in parts.keys():
		for i in range(0,5):
			parts[key].push_back(0)
	
	add_equipment(Equipment.new("sword", [Part.new("m",0),Part.new("m",0)]))
	add_equipment(Equipment.new("sword", [Part.new("m",0),Part.new("m",0),Part.new("f",0)]))
	add_equipment(Equipment.new("sword", [Part.new("m",1),Part.new("m",1),Part.new("f",0)]))
	add_equipment(Equipment.new("sword", [Part.new("m",1),Part.new("m",1),Part.new("f",1)]))
	add_equipment(Equipment.new("sword", [Part.new("m",2),Part.new("m",2),Part.new("f",1)]))
	add_equipment(Equipment.new("sword", [Part.new("m",2),Part.new("m",2),Part.new("f",2)]))
	
	add_equipment(Equipment.new("armor", [Part.new("m",0),Part.new("s",0),Part.new("s",0)]))
	add_equipment(Equipment.new("armor", [Part.new("m",0),Part.new("s",0),Part.new("s",0),Part.new("f",0),Part.new("f",0)]))
	add_equipment(Equipment.new("armor", [Part.new("m",1),Part.new("s",0),Part.new("s",0),Part.new("f",0),Part.new("f",0)]))
	add_equipment(Equipment.new("armor", [Part.new("m",1),Part.new("s",1),Part.new("s",1),Part.new("f",0),Part.new("f",0)]))
	add_equipment(Equipment.new("armor", [Part.new("m",1),Part.new("s",1),Part.new("s",1),Part.new("f",1),Part.new("f",1)]))
	add_equipment(Equipment.new("armor", [Part.new("m",2),Part.new("s",1),Part.new("s",1),Part.new("f",1),Part.new("f",1)]))
	add_equipment(Equipment.new("armor", [Part.new("m",2),Part.new("s",2),Part.new("s",2),Part.new("f",1),Part.new("f",1)]))
	add_equipment(Equipment.new("armor", [Part.new("m",2),Part.new("s",2),Part.new("s",2),Part.new("f",2),Part.new("f",2)]))
	
	
	add_equipment(Equipment.new("dagger", [Part.new("m",0),Part.new("f",0)]))
	curWeapon = 0
	curArmor = -1
	pass # Replace with function body.

func add_part(p : Part, amount : int):
	var result = parts[p.type][p.rarity] + amount
	if result < 0:
		return false
		
	parts[p.type][p.rarity] = result
	return true

func add_parts(partsToAdd : Array, quantities : Array):
	if partsToAdd.size() > quantities.size():
		return false;
		
	var success = true
	var ind 
	for i in partsToAdd.size():
		ind = i
		if !add_part(partsToAdd[i], quantities[i]):
			success = false
			break
	
	if !success:
		for i in range(0, ind):
			add_part(partsToAdd[i], -quantities[i])
	
	return success

func remove_equipment(index):
	if index <0 or index >= equipment.size():
		return null
		
	if index == curWeapon:
		curWeapon = -1
	elif index < curWeapon:
		curWeapon -= 1
		
	if index == curArmor:
		curArmor = -1
	elif index < curArmor:
		curArmor -= 1
	
	var equip = equipment[index]
	equipment.remove_at(index)
	return equip

func add_equipment(equip : Equipment):
	equipment.insert(0, equip)
	if curWeapon >= 0:
		curWeapon+=1
	if curArmor >= 0:
		curArmor+=1
		
func compare_equip(a,b):
	return a.value < b.value

func set_cur_equip(i):
	if equipment[i].is_weapon():
		if curWeapon == i:
			curWeapon = -1
		else:
			curWeapon = i
	else:
		if curArmor == i:
			curArmor = -1
		else:
			curArmor = i

func get_attack():
	if curWeapon >=0:
		return equipment[curWeapon].value
	else:
		return 1

func get_defense():
	var base = 10
	if curArmor >=0:
		return base+equipment[curArmor].value
	else:
		return base
	
