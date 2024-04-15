extends Node2D

var blacksmith
var forge : Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	blacksmith = $Blacksmith
	forge = $ForgeMenu
	$Anvil/Aura.visible = false
	_on_forge_menu_exit()
	pass # Replace with function body.
	

func _on_anvil_button_down():
	blacksmith.active = false
	$Anvil/Aura.visible = false
	forge.visible = true
	forge.set_process(true)
	forge.open()
	pass # Replace with function body.


func _on_forge_menu_exit():
	blacksmith.active = true
	
	forge.visible = false
	forge.set_process(false)
	
	pass # Replace with function body.


func _on_anvil_mouse_entered():
	if !forge.visible:
		$Anvil/Aura.visible = true
	pass # Replace with function body.


func _on_anvil_mouse_exited():
	$Anvil/Aura.visible = false
	pass # Replace with function body.
