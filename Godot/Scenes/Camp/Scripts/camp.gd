extends Node2D

var blacksmith
var forge : Node2D

var touchingLizor : bool
var mouse:InputEventMouseMotion
var heartParticles

var book

signal toMap()

# Called when the node enters the scene tree for the first time.
func _ready():
	heartParticles = $Lizor/GPUParticles2D
	blacksmith = $Blacksmith
	forge = $ForgeMenu
	
	mouse = InputEventMouseMotion.new()
	touchingLizor = false

	$Anvil/Aura.visible = false

func _process(_delta):
	if touchingLizor and Input.is_action_pressed("Pet") and !forge.visible:
		heartParticles.amount_ratio = max(Input.get_last_mouse_velocity().length()/2000, .1)
	else:
		heartParticles.amount_ratio = 0

# open/close forge
func _on_anvil_button_down():
	blacksmith.active = false
	$Anvil/Aura.visible = false
	forge.visible = true
	forge.set_process(true)
	forge.open()

func _on_forge_menu_exit():
	blacksmith.active = true
	
	forge.visible = false
	forge.set_process(false)

# anvil glow when hovered over
func _on_anvil_mouse_entered():
	if !forge.visible:
		$Anvil/Aura.visible = true

func _on_anvil_mouse_exited():
	$Anvil/Aura.visible = false

# detects if mouse is touching lizard
func _on_lizor_mouse_entered():
	touchingLizor =true

func _on_lizor_mouse_exited():
	touchingLizor =false

# tells main to switch to map
func _on_switch_button_down():
	emit_signal("toMap")

func _on_book_but_button_down():
	if book.visible:
		book.close()
	else:
		if forge.visible:
			book.open(book.start["help"]+2)
		else:
			book.open()
	
