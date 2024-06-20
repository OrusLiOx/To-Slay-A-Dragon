extends Node2D

var blacksmith
var forge : Node2D

var touchingLizor : bool
var mouse:InputEventMouseMotion
var heartParticles

signal toMap()

# Called when the node enters the scene tree for the first time.
func _ready():
	heartParticles = $Lizor/GPUParticles2D
	blacksmith = $Blacksmith
	forge = $ForgeMenu
	
	mouse = InputEventMouseMotion.new()
	touchingLizor = false

	$Anvil/Aura.visible = false
	open()
	pass # Replace with function body.

func open():
	_on_forge_menu_exit()

func _process(_delta):
	if touchingLizor and Input.is_action_pressed("Pet") and !forge.visible:
		heartParticles.amount_ratio = max(Input.get_last_mouse_velocity().length()/2000, .1)
	else:
		heartParticles.amount_ratio = 0

# open/close forge
func _on_anvil_button_down():
	blacksmith.active = false
	$Anvil/Aura.visible = false
	$Switch.visible = false
	$BookBut.visible = false
	forge.visible = true
	forge.set_process(true)
	forge.open()
	pass # Replace with function body.

func _on_forge_menu_exit():
	$Switch.visible = true
	$BookBut.visible = true
	blacksmith.active = true
	
	forge.visible = false
	forge.set_process(false)
	
	pass # Replace with function body.

# anvil glow when hovered over
func _on_anvil_mouse_entered():
	if !forge.visible:
		$Anvil/Aura.visible = true
	pass # Replace with function body.

func _on_anvil_mouse_exited():
	$Anvil/Aura.visible = false
	pass # Replace with function body.

# detects if mouse is touching lizard
func _on_lizor_mouse_entered():
	touchingLizor =true
	pass # Replace with function body.

func _on_lizor_mouse_exited():
	touchingLizor =false
	pass # Replace with function body.

# tells main to switch to map
func _on_switch_button_down():
	emit_signal("toMap")
	open()
	pass # Replace with function body.

func _on_book_but_button_down():
	$Book.visible = true
	$BookBut.visible = false
	$Switch.visible = false
	pass # Replace with function body.


func _on_book_close_book():
	$BookBut.visible = true
	$Switch.visible = true
	pass # Replace with function body.
