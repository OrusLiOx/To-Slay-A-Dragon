extends Node2D
@export var partButScene: PackedScene
@export var equipButScene: PackedScene

var storage
var activeBlueprint : String
var selectedParts:Array
var builtEquip
var partCount

signal exit()

# Called when the node enters the scene tree for the first time.
func _ready():
	selectedParts = [[],[]]
	partCount = {
		"m": -1,
		"f": -1,
		"s": -1
	}
	storage = $Main/Storage
	generate_blueprint_base()
	
	activeBlueprint = "sword"

func _process(_delta):
	if Input.is_action_just_pressed("Exit"):
		_on_exit_pressed()
	if Input.is_action_just_pressed("Craft") and !builtEquip.disabled:
		craft_equip()
	if Input.is_action_just_pressed("Clear"):
		load_blueprint(activeBlueprint)

func generate_blueprint_base():
	var parent = $Main/ActiveBlueprint/SelectedParts
	
	for x in range(0,4):
		var child = partButScene.instantiate()
		parent.add_child(child)
		child.make_part("",-2)
		child.position = Vector2(x*125,0)
		child.disabled = true
		selectedParts[0].push_back(child)
		child.get_child(1).visible = false
		
		child.pressed.connect(return_material.bind(child))
	
	for x in range(0,2):
		var child = partButScene.instantiate()
		parent.add_child(child)
		child.make_part("",-2)
		child.position = Vector2(x*125,125)
		child.disabled = true
		selectedParts[1].push_back(child)
		child.get_child(1).visible = false
		
		child.pressed.connect(return_material.bind(child))
	
	builtEquip = equipButScene.instantiate()
	builtEquip.pressed.connect(craft_equip)
	$Main/ActiveBlueprint.add_child(builtEquip)
	builtEquip.position = Vector2(parent.position.x,parent.position.y+250)
	builtEquip.visible = true
	builtEquip.disabled = false

# handle switching blueprints	
func load_blueprint(type, clear = false):
	if clear:
		for i in range(0,6):
			var r = i/4
			var c = i%4
			if selectedParts[r][c].part.rarity >= 0:
				Storage.add_part(selectedParts[r][c].part,1)
				storage.update()
				selectedParts[r][c].make_part(selectedParts[r][c].part.type,-1)
			selectedParts[r][c].disabled = true
				
	activeBlueprint = type
	$Main/ActiveBlueprint/Type.text = type.capitalize()
	
	match(type):
		"dagger": 
			set_blueprint_slots(["m","","","","f",""])
		"sword": 
			set_blueprint_slots(["m","m","","","f",""])
		"greatsword": 
			set_blueprint_slots(["m","m","m","","f",""])
		"light armor": 
			set_blueprint_slots(["m","s","","","f",""])
		"armor": 
			set_blueprint_slots(["m","s","s","","f","f"])
		"heavy armor": 
			set_blueprint_slots(["m","s","s","s","f","f"])
		_:
			set_blueprint_slots(["","","","","",""])
			builtEquip.visible = false
	
	storage.update()
	update_equip_stats()

func set_blueprint_slots(slots):
	partCount["m"] = 0
	partCount["f"] = 0
	partCount["s"] = 0
	for i in range(0,4):
		if slots[i] != "":
			partCount[slots[i]] += 1
		set_blueprint_slot(0,i,slots[i])
	for i in range(0,2):
		if slots[4+i] != "":
			partCount["f"] += 1
		set_blueprint_slot(1,i,slots[4+i])
		
func set_blueprint_slot(r, c, t):
	if t =="": # slot not part of blueprint
		if selectedParts[r][c].part.rarity >= 0:
			Storage.add_part(selectedParts[r][c].part,1)
		selectedParts[r][c].set_part(Part.new(t,-2))
	elif selectedParts[r][c].part.type != t: # not the same type of part as previous blueprint
		if selectedParts[r][c].part.rarity >= 0:
			Storage.add_part(selectedParts[r][c].part,1)
		selectedParts[r][c].set_part(Part.new(t,-1))

#open/close
func open():
	load_blueprint(activeBlueprint)

func _on_exit_pressed():
	if !builtEquip.disabled:
		craft_equip(true)
		#
	#for c in range(0,4):
		#set_blueprint_slot(0,c,"")
	#for c in range(0,2):
		#set_blueprint_slot(1,c,"")
			
	emit_signal("exit")

# add/remove materials
func _on_storage_use(part):
	if partCount[part.type] == 0:
		return
	
	add_material(part, true)

func add_material(part, remove):
	Audio.play("AnvilUI")
	# look for empty slot
	for arr in selectedParts:
		for partBut in arr:
			if part.type == partBut.part.type and partBut.part.rarity == -1:
				if remove:
					Storage.add_part(part, -1)
				partBut.set_part(part)
				partBut.disabled = false
				load_blueprint(activeBlueprint)
				update_equip_stats()
				return
	
	# if no empty slot, go in order
	var start = 0
	var offset = 0
	var p = 0
	if part.type == "s":
		start = 1
	if part.type == "f":
		p = 1
	
	for l in range(partCount[part.type]):
		if selectedParts[p][start+offset].part.rarity != part.rarity:
			break
		offset += 1
	if offset >= partCount[part.type]:
		offset = 0
		
	var but = selectedParts[p][start + offset]
	if remove:
		Storage.add_part(part, -1)
	if but.part.rarity != -1:
		Storage.add_part(but.part, 1)
	but.set_part(part)
	but.disabled = false
	update_equip_stats()

func return_material(partBut):
	Audio.play("AnvilUI")
	Storage.add_part(partBut.part, 1)
	partBut.set_part(Part.new(partBut.part.type,-1))
	partBut.update()
	update_equip_stats()

func update_equip_stats():
	# determine value of crafted equipment
	var label = $Main/ActiveBlueprint/EquipStat
	if activeBlueprint == "":
		return
		
	var final = 0
	
	for arr in selectedParts:
		for partBut in arr:
			if partBut.part.rarity >=0:
				final+=partBut.part.get_value()
	
	if activeBlueprint.contains("armor"):
		label.text ="Defense: "
	else:
		label.text = "Attack: "
	label.text += str(final)
	
	
	storage.update()
	var type = activeBlueprint
	# if row 0 isn't filled, you can't craft
	if activeBlueprint == "sword" and selectedParts[0][0].part.rarity >=0 and selectedParts[0][1].part.rarity == -1 and selectedParts[1][0].part.rarity == -1:
		type = "dagger"
	else:
		for partBut in selectedParts[0]:
			if partBut.part.rarity == -1:
				builtEquip.set_ghost(activeBlueprint)
				builtEquip.disabled = true
				type = activeBlueprint
				return
			
	# if row 0 is filled, build equip based on selected parts
	var parts:Array = []
	for arr in selectedParts:
		for partBut in arr:
			if partBut.part.rarity >= 0:
				parts.push_back(partBut.part)

	builtEquip.set_equip(Equipment.new(type, parts))
	builtEquip.disabled = false

# finalize crafting
func craft_equip(mute = false):
	if !mute:
		Audio.play("AnvilClang")
	# disassemble current
	var equip
	if activeBlueprint.contains("armor"):
		equip = $Main/Equipped/Armor.equipment
	else:
		equip = $Main/Equipped/Weapon.equipment
	if equip != null:
		for part in equip.parts:
			Storage.add_part(part, 1)
		
	
	# put equip in storage and set as current
	Storage.add_equipment(builtEquip.equipment)
	Storage.set_cur_equip(0)
	# clear blueprint
	for arr in selectedParts:
		for partBut in arr:
			if partBut.part.rarity != -2:
				partBut.set_part(Part.new(partBut.part.type, -1))
				partBut.update()
	update_equip_stats()
	$Main/Equipped.load_current()

func clicked_equipment(type, equip):
	# load corresponding blueprint
	if type != "armor":
		type = "sword"
	
	var clear = false
	if type != activeBlueprint:
		if !builtEquip.disabled:
			craft_equip()
		else:
			clear = true
	
	load_blueprint(type,clear)
	
	if equip == null:
		return
	Audio.play("AnvilUI")
	# add all parts
	for part in equip.parts:
		if part.rarity >=0:
			add_material(part, false)
	
	# load equip
	update_equip_stats()
