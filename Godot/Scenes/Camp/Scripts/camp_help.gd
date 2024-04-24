extends Node2D

@export var storage :Node2D

var text
var header
var count

# Called when the node enters the scene tree for the first time.
func _ready():
	text = $Description
	header = $Title
	count = 1
	_on_control_mouse_exited()
	storage = storage.get_child(3)
	pass # Replace with function body.


func _on_help_mouse_entered():
	count+=1
	header.text = "Help Button"
	text.text = "Toggles this text box on and off."
	pass # Replace with function body.

func _on_exit_mouse_entered():
	count+=1
	header.text = "Exit Button"
	text.text = "Closes the forge menu."
	pass # Replace with function body.

func _on_equipped_mouse_entered():
	count+=1
	header.text = "Equipped Menu"
	text.text = "Displays the weapon and armor that you currently have equipped and the stats that you get from that equipment."
	pass # Replace with function body.

func _on_blueprint_select_mouse_entered():
	count+=1
	header.text = "Blueprint Selection"
	text.text = "Lets you choose what type of equipment you are forging.\n\nThe blueprints placed lower on the menu are stronger but require more materials."
	pass # Replace with function body.

func _on_blueprint_active_mouse_entered():
	count+=1
	header.text = "Active Blueprint"
	text.text = "Displays materials being used to forge a particular equipment."
	pass # Replace with function body.

func _on_storage_mouse_entered():
	count+=1
	if storage.visible:
		header.text = "Storage: Materials"
		text.text = "Displays how much of every material you have.\n\n"
		text.text += "Hovering over a material displays information about it.\n"
		text.text += "Clicking on a material that you have adds it to the active blueprint if possible."
	else:
		header.text = "Storage: Equipment"
		text.text = "Displays all crafted equipment.\n\n"
		text.text += "Hovering over an equipment displays its stats.\n"
		text.text += "Clicking on an equipment equips/unequips it"
	pass # Replace with function body.

func _on_required_mouse_entered():
	count+=1
	header.text = "Active Blueprint: Required Materials"
	text.text = "Indicates materials that are required to forge the selected equipment.\n\n"
	text.text+= "Use the storage menu to the right to add material to the blueprint.\n"
	text.text+= "Clicking on a selected material in the blueprint will remove it."
	pass # Replace with function body.

func _on_optional_mouse_entered():
	count+=1
	header.text = "Active Blueprint: Optional Materials"
	text.text = "Indicates materials optional material that can be added to make the equipment stronger.\n\n"
	text.text += "Use the storage menu to the right to add material to the blueprint.\n"
	text.text += "Clicking on a selected material in the blueprint will remove it."
	pass # Replace with function body.

func _on_crafted_mouse_entered():
	count+=1
	header.text = "Active Blueprint: Equipment Preview"
	text.text = "Displays the equipment to be forged and the stats it will provide.\n\n"
	text.text += "If all required materials are filled in, clicking this slot will forge the equipment and equip it.\n"
	pass # Replace with function body.

func _on_materials_mouse_entered():
	count+=1
	header.text = "Storage: Materials Tab"
	text.text = "Sets storage to material display.\n\n"
	pass # Replace with function body.

func _on_equipment_mouse_entered():
	count+=1
	header.text = "Storage: Equipment Tab"
	text.text = "Sets storage to equipment display.\n\n"
	pass # Replace with function body.

func _on_control_mouse_exited():
	count -= 1
	if count == 0:
		header.text ="Help: Forge Menu"
		text.text="Hover the mouse over whatever you want to learn about.\n\n"
		text.text+="NOTE: you cannot interact with most Forge Menu options while this help menu is open. Click the ? button in the botton right to close the help menu."
