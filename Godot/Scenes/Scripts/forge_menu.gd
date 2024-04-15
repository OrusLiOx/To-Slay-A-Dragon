extends Node2D
@export var ghostButScene: PackedScene
@export var partButScene: PackedScene

var storage
var activeBlueprint : String
var selectedParts:Array

signal exit()

# Called when the node enters the scene tree for the first time.
func _ready():
	selectedParts = [[],[]]
	activeBlueprint =""
	storage = $Storage
	generate_blueprint_base()
	load_blueprint_selection()
	pass # Replace with function body.

# blueprint stuff
func load_blueprint_selection():
	var parent = $BlueprintSelect/Buttons
	var x = 0
	var y = 0
	for type in ["dagger","sword","greatsword","light armor","med armor","heavy armor"]:
		var child = ghostButScene.instantiate()
		parent.add_child(child)
		child.set_type(type)
		child.position = Vector2(x,y)
		if y <250:
			y+=125
		else:
			y=0
			x+=125
			
		child.button_down.connect(load_blueprint.bind(type))
	pass

func generate_blueprint_base():
	var parent = $ActiveBlueprint/Buttons
	
	for x in range(0,3):
		var child = partButScene.instantiate()
		parent.add_child(child)
		child.make_part("",-2)
		child.position = Vector2(x*125,0)
		child.disabled = true
		selectedParts[0].push_back(child)
		child.get_child(1).visible = false
		
		child.button_down.connect(return_material.bind(child))
	
	for x in range(0,3):
		var child = partButScene.instantiate()
		parent.add_child(child)
		child.make_part("",-2)
		child.position = Vector2(x*125,125)
		child.disabled = true
		selectedParts[1].push_back(child)
		child.get_child(1).visible = false
		
		child.button_down.connect(return_material.bind(child))
		
	pass

func load_blueprint(type):
	activeBlueprint = type
	$ActiveBlueprint.visible = true
	
	match(type):
		"dagger": 
			set_blueprint_slot(0,0,"m")
			set_blueprint_slot(0,1,"")
			set_blueprint_slot(0,2,"")
			
			set_blueprint_slot(1,0,"f")
			set_blueprint_slot(1,1,"")
			set_blueprint_slot(1,2,"")
		"sword": 
			set_blueprint_slot(0,0,"m")
			set_blueprint_slot(0,1,"m")
			set_blueprint_slot(0,2,"")
			
			set_blueprint_slot(1,0,"f")
			set_blueprint_slot(1,1,"")
			set_blueprint_slot(1,2,"")
		"greatsword": 
			set_blueprint_slot(0,0,"m")
			set_blueprint_slot(0,1,"m")
			set_blueprint_slot(0,2,"m")
			
			set_blueprint_slot(1,0,"f")
			set_blueprint_slot(1,1,"")
			set_blueprint_slot(1,2,"")
		"light armor": 
			set_blueprint_slot(0,0,"s")
			set_blueprint_slot(0,1,"")
			set_blueprint_slot(0,2,"")
			
			set_blueprint_slot(1,0,"m")
			set_blueprint_slot(1,1,"")
			set_blueprint_slot(1,2,"")
		"med armor": 
			set_blueprint_slot(0,0,"s")
			set_blueprint_slot(0,1,"s")
			set_blueprint_slot(0,2,"")
			
			set_blueprint_slot(1,0,"m")
			set_blueprint_slot(1,1,"f")
			set_blueprint_slot(1,2,"")
		"heavy armor": 
			set_blueprint_slot(0,0,"s")
			set_blueprint_slot(0,1,"s")
			set_blueprint_slot(0,2,"s")
			
			set_blueprint_slot(1,0,"m")
			set_blueprint_slot(1,1,"m")
			set_blueprint_slot(1,2,"f")
		_:
			$ActiveBlueprint.visible = false
	storage.update()
	pass

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
	load_blueprint("")
	storage.set_tab(0)
	pass

func _on_exit_button_down():
	for r in range(0,2):
		for c in range(0,3):
			set_blueprint_slot(r,c,"")
			
	emit_signal("exit")
	pass # Replace with function body.

# add/remove materials
func _on_storage_use(part):
	for arr in selectedParts:
		for partBut in arr:
			if part.type == partBut.part.type and partBut.part.rarity == -1:
				Storage.add_part(part, -1)
				partBut.set_part(part)
				partBut.disabled = false
				storage.update()
				return true
	
	pass # Replace with function body.

func return_material(partBut):
	Storage.add_part(partBut.part, 1)
	partBut.set_part(Part.new(partBut.part.type,-1))
	partBut.disabled = true
	storage.update()
