extends Node

var curWeapon : int
var curArmor : int

var equipment : Array

var parts : Dictionary
var food : Array

# Called when the node enters the scene tree for the first time.
func _ready():	
	curWeapon = -1
	curArmor = -1
	parts = { 
		's' : [],
		'f' : [],
		'm' : []
	}
	for key in parts.keys():
		for i in range(0,5):
			parts[key].push_back(0)
	
	parts["m"][0] = 1
	
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

func add_equipment(equip : Equipment):
	equipment.insert(0, equip)
	if curWeapon >= 0:
		curWeapon+=1
	if curArmor >= 0:
		curArmor+=1
	#if equip.type.contains("armor"):
		#armor.push_back(equip)
		#armor.bsearch_custom(equip, compare_equip, true)
	#else:
		#weapons.push_back(equip)
		#weapons.bsearch_custom(equip, compare_equip, true)
		
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
	if curArmor >=0:
		return equipment[curArmor].value
	else:
		return 0
	
