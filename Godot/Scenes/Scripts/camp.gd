extends Node2D

var blacksmith
var forge : Node2D

var touchingLizor : bool
var mouse:InputEventMouseMotion
var heartParticles

signal toMap()

# Called when the node enters the scene tree for the first time.
func _ready():
	mouse = InputEventMouseMotion.new()
	touchingLizor = false
	heartParticles = $Lizor/GPUParticles2D
	blacksmith = $Blacksmith
	forge = $ForgeMenu
	$Anvil/Aura.visible = false
	open()
	pass # Replace with function body.

func open():
	_on_forge_menu_exit()
	blacksmith.dialogue.modulate.a = 0

func _process(_delta):
	if touchingLizor and Input.is_action_pressed("Pet"):
		heartParticles.amount_ratio = max(Input.get_last_mouse_velocity().length()/2000, .1)
	else:
		heartParticles.amount_ratio = 0

func _on_anvil_button_down():
	blacksmith.active = false
	$Anvil/Aura.visible = false
	$Switch.visible = false
	forge.visible = true
	forge.set_process(true)
	forge.open()
	pass # Replace with function body.

func _on_forge_menu_exit():
	$Switch.visible = true
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

func _on_lizor_mouse_entered():
	touchingLizor =true
	pass # Replace with function body.

func _on_lizor_mouse_exited():
	touchingLizor =false
	pass # Replace with function body.

func _on_switch_button_down():
	emit_signal("toMap")
	open()
	pass # Replace with function body.
