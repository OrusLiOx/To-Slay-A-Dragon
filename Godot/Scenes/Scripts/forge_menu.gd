extends Node2D
@export var ghostButScene: PackedScene
@export var partButScene: PackedScene

var storage
var activeBlueprint : String
var selectedParts:Dictionary

signal exit()

# Called when the node enters the scene tree for the first time.
func _ready():
	selectedParts =
	{
		"m":
		"f":
		"s":
	}
	activeBlueprint =""
	storage = $Storage
	generate_blueprint_base()
	load_blueprint_selection()
	pass # Replace with function body.

func generate_blueprint_base():
	var parent = $ActiveBlueprint/Buttons
	
	for x in range(0,3):
		var child = partButScene.instantiate()
		parent.add_child(child)
		child.make_part("m",-1)
		child.position = Vector2(x*125,0)
		child.disabled = true
	
	for x in range(0,3):
		var child = partButScene.instantiate()
		parent.add_child(child)
		child.make_part("s",-1)
		child.position = Vector2(x*125,125)
		child.disabled = true
		
	pass

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

func load_blueprint(type):
	activeBlueprint = type
	if type =="":
		$ActiveBlueprint.visible = false
		return
	$ActiveBlueprint.visible = true
	#match(type):
		#"dagger": $Sprite.frame = 3
		#"sword": $Sprite.frame = 4
		#"greatsword": $Sprite.frame = 5
		#"light armor": $Sprite.frame = 6
		#"med armor": $Sprite.frame = 7
		#"heavy armor": $Sprite.frame = 8
	pass

func open():
	load_blueprint("")
	storage.set_tab(0)
	pass

func _on_exit_button_down():
	emit_signal("exit")
	pass # Replace with function body.


func _on_storage_use(part):
	pass # Replace with function body.
