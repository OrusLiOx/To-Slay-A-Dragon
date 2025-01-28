extends Node2D

var forge : Node2D

var touchingLizor : bool
var mouse:InputEventMouseMotion
var heartParticles

var book

signal toMap()
signal openBook()

# Called when the node enters the scene tree for the first time.
func _ready():
	heartParticles = $Lizard/Lizor/GPUParticles2D
	forge = $ForgeMenu
	book = $Book
	
	mouse = InputEventMouseMotion.new()
	touchingLizor = false

func _process(_delta):
	if touchingLizor and Input.is_action_pressed("Pet") and !forge.visible:
		heartParticles.amount_ratio = max(Input.get_last_mouse_velocity().length()/2000, .1)
	else:
		heartParticles.amount_ratio = 0

# open/close forge
func _on_anvil_pressed():
	Audio.play("AnvilClang")
	forge.visible = true
	forge.set_process(true)
	forge.open()

func _on_forge_menu_exit():
	forge.visible = false
	forge.set_process(false)

# detects if mouse is touching lizard
func _on_lizor_mouse_entered():
	touchingLizor =true

func _on_lizor_mouse_exited():
	touchingLizor =false

# buttons
func _on_switch_pressed():
	emit_signal("toMap")

func _on_book_but_pressed():
	emit_signal("openBook")
	
