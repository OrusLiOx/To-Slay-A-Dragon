extends Node

var curWeapon : int
var curArmor : int

var equipment : Array

var parts : Dictionary
var food : Array

# Called when the node enters the scene tree for the first time.
func _ready():	
	curWeapon = 0
	curArmor = -1
	parts = { 
		's' : [],
		'f' : [],
		'm' : []
	}
	for key in parts.keys():
		for i in range(0,5):
			parts[key].push_back(0)
	
	parts["m"][0] = 12
	parts["s"][2] = 12
	equipment.push_back(Equipment.new("dagger", [Part.new("m",0), Part.new("f",3)]))
	equipment.push_back(Equipment.new("dagger", [Part.new("m",2), Part.new("f",2)]))
	
		
	
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
	curWeapon+=1
	curArmor+=1
	#if equip.type.contains("armor"):
		#armor.push_back(equip)
		#armor.bsearch_custom(equip, compare_equip, true)
	#else:
		#weapons.push_back(equip)
		#weapons.bsearch_custom(equip, compare_equip, true)
		
func compare_equip(a,b):
	return a.value < b.value
