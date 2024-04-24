extends Node2D
@export var partButScene: PackedScene
@export var equipButScene: PackedScene

var storage
var activeBlueprint : String
var selectedParts:Array
var builtEquip
var partQueue : Dictionary

var types

signal exit()

# Called when the node enters the scene tree for the first time.
func _ready():
	types = ["dagger","sword","greatsword","light armor","med armor","heavy armor"]
	selectedParts = [[],[]]
	partQueue = {
		"m": [-1],
		"f": [-1],
		"s": [-1]
	}
	storage = $Storage
	generate_blueprint_base()
	load_blueprint_selection()
	
	load_blueprint("dagger")
	pass # Replace with function body.

func _process(_delta):
	if Input.is_action_just_pressed("Exit"):
		_on_exit_button_down()
	if Input.is_action_just_pressed("Craft") and !builtEquip.disabled:
		craft_equip()
	if Input.is_action_just_pressed("Clear"):
		load_blueprint(activeBlueprint)
	
	for i in range(0,6):
		if Input.is_action_just_pressed("Blueprint"+str(i+1)):
			load_blueprint(types[i])

# initial blueprint menu setup
func load_blueprint_selection():
	var parent = $BlueprintSelect/Blueprints
	var x = 0
	var y = 0
	for type in types:
		var child = equipButScene.instantiate()
		parent.add_child(child)
		child.set_ghost(type)
		child.position = Vector2(x,y)
		if y <250:
			y+=125
		else:
			y=0
			x+=125
			
		child.button_down.connect(blueprint_button_down.bind(type))
	pass

func generate_blueprint_base():
	var parent = $ActiveBlueprint/SelectedParts
	
	for x in range(0,4):
		var child = partButScene.instantiate()
		parent.add_child(child)
		child.make_part("",-2)
		child.position = Vector2(x*125,0)
		child.disabled = true
		selectedParts[0].push_back(child)
		child.get_child(1).visible = false
		
		child.button_down.connect(return_material.bind(child))
	
	for x in range(0,2):
		var child = partButScene.instantiate()
		parent.add_child(child)
		child.make_part("",-2)
		child.position = Vector2(x*125,125)
		child.disabled = true
		selectedParts[1].push_back(child)
		child.get_child(1).visible = false
		
		child.button_down.connect(return_material.bind(child))
	
	builtEquip = equipButScene.instantiate()
	$ActiveBlueprint.add_child(builtEquip)
	builtEquip.position = Vector2(parent.position.x,parent.position.y+250)
	builtEquip.visible = true
	builtEquip.disabled = false
	builtEquip.button_down.connect(craft_equip)
	
	pass

# handle switching blueprints
func blueprint_button_down(type):
	# if active blueprint isn't changed, clear parts from selection
	if type == activeBlueprint:
		for i in range(0,4):
			if selectedParts[0][i].part.rarity >= 0:
				Storage.add_part(selectedParts[0][i].part,1)
				storage.update()
				selectedParts[0][i].make_part(selectedParts[0][i].part.type,-1)
				selectedParts[0][i].disabled = true
	else:
		load_blueprint(type)
		
func load_blueprint(type):
	activeBlueprint = type
	$ActiveBlueprint/Type.text = type.capitalize()
	
	match(type):
		"dagger": 
			set_blueprint_slots(["m","","","","f",""])
		"sword": 
			set_blueprint_slots(["m","m","","","f",""])
		"greatsword": 
			set_blueprint_slots(["m","m","m","","f",""])
		"light armor": 
			set_blueprint_slots(["m","s","","","f",""])
		"med armor": 
			set_blueprint_slots(["m","s","s","","f","f"])
		"heavy armor": 
			set_blueprint_slots(["m","s","s","s","f","f"])
		_:
			set_blueprint_slots(["","","","","",""])
			builtEquip.visible = false
	
	storage.update()
	update_equip_stats()
	pass

func set_blueprint_slots(slots):
	partQueue["m"] = []
	partQueue["f"] = []
	partQueue["s"] = []
	for i in range(0,4):
		if slots[i] != "":
			partQueue[slots[i]].push_back(i)
		set_blueprint_slot(0,i,slots[i])
	for i in range(0,2):
		if slots[4+i] != "":
			partQueue["f"].push_back(i)
		set_blueprint_slot(1,i,slots[4+i])
		
func set_blueprint_slot(r, c, t):
	if t =="":
		if selectedParts[r][c].part.rarity >= 0:
			Storage.add_part(selectedParts[r][c].part,1)
		selectedParts[r][c].set_part(Part.new(t,-2))
	elif selectedParts[r][c].part.type != t:
		if selectedParts[r][c].part.rarity >= 0:
			Storage.add_part(selectedParts[r][c].part,1)
		selectedParts[r][c].set_part(Part.new(t,-1))

#open/close
func open():
	load_blueprint(activeBlueprint)
	storage.set_tab(0)
	pass

func _on_exit_button_down():
	for c in range(0,4):
		set_blueprint_slot(0,c,"")
	for c in range(0,2):
		set_blueprint_slot(0,c,"")
			
	emit_signal("exit")
	pass # Replace with function body.

# add/remove materials
func _on_storage_use(part):
	if partQueue[part.type].is_empty():
		return
	# look for empty slot
	for arr in selectedParts:
		for partBut in arr:
			if part.type == partBut.part.type and partBut.part.rarity == -1:
				Storage.add_part(part, -1)
				partBut.set_part(part)
				partBut.disabled = false
				load_blueprint(activeBlueprint)
				update_equip_stats()
				return
	
	# if no empty slot, go in order
	var i = partQueue[part.type].front()
	var p = 0
	partQueue[part.type].pop_front()
	partQueue[part.type].push_back(i)
	if part.type == "f":
		p = 1
	
	var but = selectedParts[p][i]
	Storage.add_part(part, -1)
	if but.part.rarity != -1:
		Storage.add_part(but.part, 1)
	but.set_part(part)
	but.disabled = false
	update_equip_stats()
	
	pass # Replace with function body.

func return_material(partBut):
	Storage.add_part(partBut.part, 1)
	partBut.set_part(Part.new(partBut.part.type,-1))
	partBut.update()
	update_equip_stats()

func update_equip_stats():
	# determine value of crafted equipment
	var label = $ActiveBlueprint/EquipStat
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
	
	# if row 0 isn't filled, you can't craft
	for partBut in selectedParts[0]:
		if partBut.part.rarity == -1:
			builtEquip.set_ghost(activeBlueprint)
			builtEquip.disabled = true
			return
	# if row 0 is filled, build equip based on selected parts
	var parts:Array = []
	for arr in selectedParts:
		for partBut in arr:
			if partBut.part.rarity > -1:
				parts.push_back(partBut.part)
	builtEquip.set_equip(Equipment.new(activeBlueprint, parts))
	builtEquip.disabled = false

# finalize crafting
func craft_equip():
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

func _on_help_button_down():
	$HelpStuff.visible = !$HelpStuff.visible
