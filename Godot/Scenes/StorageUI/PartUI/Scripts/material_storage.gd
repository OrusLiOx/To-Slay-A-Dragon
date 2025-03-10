extends Node2D
@export var buttonScene: PackedScene

signal use(part:Part)

# Called when the node enters the scene tree for the first time.
func _ready():
	var parent = $Buttons
	
	var x = 0
	for t in ["m","f","s"]:
		for r in range(0,3):
			var child = buttonScene.instantiate()
			child.make_part(t, r)
			parent.add_child(child)
			child.position.x = x
			child.position.y = r*125
			child.update()
			
			child.mouse_entered.connect(set_item_display.bind(true,child.part))
			child.mouse_exited.connect(set_item_display.bind(false,child.part))
			
			child.pressed.connect(emit_signal.bind("use", child.part))
		x +=125
	pass # Replace with function body.

func update():
	for child in $Buttons.get_children():
		child.update()

func set_active(state):
	visible = state

func set_view_only(state):
	for butt in $Buttons.get_children():
		butt.disabled = state

func set_item_display(vis:bool, part : Part):
	$PartDisplay.visible = vis
	
	if vis:
		var text = part.get_name() + "\n"
		text += "Value: " + str(part.get_value()) + "\n"
		$PartDisplay/Label.text = text
