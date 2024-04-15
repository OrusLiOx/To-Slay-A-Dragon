extends Button
var active

var inBlacksmith:bool
var inTextBox : bool
var dialogue
var aura

var dialogueOptions : Array
var specialDialogue : Array

# Called when the node enters the scene tree for the first time.
func _ready():
	active = true
	inBlacksmith = false
	inTextBox = false
	dialogue = $Dialogue
	dialogue.modulate.a = 0
	aura = $Aura
	aura.visible = false
	
	dialogueOptions.push_back("hello")
	dialogueOptions.push_back("die a log")
	dialogueOptions.push_back("dialogue")
	dialogueOptions.push_back("test stuff")
	dialogueOptions.push_back("Just because she has scales and breathes fire doesn't mean she's a dragon.")
	dialogueOptions.push_back("Did you find any treats for the little guy?")
	dialogueOptions.push_back("No! You can not take her scales!")
	dialogueOptions.push_back("Don't approach the little guy from the left, you might startle her.")
	dialogueOptions.push_back("I know she's not little anymore, but she'll always be a hatchling in my eyes.")
	
	specialDialogue.push_back("special!")
	specialDialogue.push_back("lizor!")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !active or (!inBlacksmith and !inTextBox):
		dialogue.modulate.a = move_toward(dialogue.modulate.a,0,.5*delta)
	pass

func _on_button_down():
	if !active:
		return
		
	dialogue.modulate.a = 1
	if specialDialogue.is_empty():
		dialogue.text = dialogueOptions.pick_random()
	else:
		dialogue.text = specialDialogue.front()
		specialDialogue.remove_at(0);
	pass # Replace with function body.

func _on_mouse_entered():
	if !active:
		return
	aura.visible = true
	inBlacksmith = true
	if dialogue.modulate.a >0:
		dialogue.modulate.a = 1
	pass # Replace with function body.

func _on_mouse_exited():
	if !active:
		return
	aura.visible = false
	inBlacksmith = false
	pass # Replace with function body.

func _on_backdrop_mouse_entered():
	if !active:
		return
	inTextBox = true
	if dialogue.modulate.a >0:
		dialogue.modulate.a = 1
	pass # Replace with function body.

func _on_backdrop_mouse_exited():
	if !active:
		return
	inTextBox = false
	pass # Replace with function body.
