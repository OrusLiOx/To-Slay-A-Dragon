extends Node2D
var armorDisplay
var weaponDisplay
@export var matButScene: PackedScene

signal pressed_equip(type, equip)

# Called when the node enters the scene tree for the first time.
func _ready():
	armorDisplay = $Armor
	weaponDisplay = $Weapon
	
	armorDisplay.mouse_entered.connect(display_equip_info.bind(armorDisplay))
	weaponDisplay.mouse_entered.connect(display_equip_info.bind(weaponDisplay))
	
	armorDisplay.mouse_exited.connect(hide_equip_display)
	weaponDisplay.mouse_exited.connect(hide_equip_display)
	
	armorDisplay.pressed.connect(pressed_equipment.bind("armor",armorDisplay))
	weaponDisplay.pressed.connect(pressed_equipment.bind("weapon",weaponDisplay))
	
	load_current()
	hide_equip_display()
	pass # Replace with function body.

func pressed_equipment(type, equip):
	var display
	if type == "armor":
		Storage.remove_equipment(Storage.curArmor)
		display = armorDisplay
	else:
		Storage.remove_equipment(Storage.curWeapon)
		display = weaponDisplay
	emit_signal("pressed_equip", type, equip.equipment)
	load_current()
	display_equip_info(display)

# display equipment stats when mouse over
func display_equip_info(equipDisplay):
	var equip = equipDisplay.equipment
	if equip == null:
		#if equipDisplay.name =="Armor":
			#$Info/Label.text = "Armor\nNone"
		#else:
			#$Info/Label.text = "Weapon\nNone"
		for child in $Info/Parts.get_children():
			child.queue_free()
		return
	
	$Info/Label.text = "Parts"
	#if equip.is_weapon():
		#$Info/Label.text = equip.type.capitalize() + "\nAttack: " + str(equip.value)
	#else:
		#$Info/Label.text =  equip.type.capitalize() + "\nHealth: " + str(equip.value)
		
	var x = 0
	var y = 0
	var parent = $Info/Parts
		
	for part in equip.parts:
		var child = matButScene.instantiate()
		child.set_part(part)
		parent.add_child(child)
		child.position.x = x
		child.position.y = y
		child.disabled = true
			
		if x < 250:
			x += 125
		else:
			x = 0
			y+=125

func hide_equip_display():
	$Info/Label.text = ""
	for child in $Info/Parts.get_children():
		child.queue_free()

func load_current():
	if Storage.curArmor != -1:
		armorDisplay.set_equip(Storage.equipment[Storage.curArmor])
	else:
		armorDisplay.set_ghost("armor")
	
	if Storage.curWeapon != -1:
		weaponDisplay.set_equip(Storage.equipment[Storage.curWeapon])
	else:
		weaponDisplay.set_ghost("sword")
		
	$Stats.text = "Attack: " + str(Storage.get_attack()) +"\nHealth: " + str(Storage.get_defense())
	
