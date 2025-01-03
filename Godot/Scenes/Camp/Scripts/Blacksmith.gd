extends Node2D
var active

var inBlacksmith:bool
var inTextBox : bool
var dialogue

var dialogueOptions : Array
var specialDialogue : Array

# Called when the node enters the scene tree for the first time.
func _ready():
	active = true
	inBlacksmith = false
	inTextBox = false
	dialogue = $Dialogue
	dialogue.modulate.a = 0
	
	dialogueOptions.push_back("Be careful if you see any other magma lizards. They aren't usually so friendly.")
	dialogueOptions.push_back("You can pet the little lady, she won't bite.")
	dialogueOptions.push_back("Just because she has scales and breathes fire doesn't mean she's a dragon.")
	dialogueOptions.push_back("Did you find any treats for the little lady?")
	dialogueOptions.push_back("No! You can not take her scales!")
	dialogueOptions.push_back("Don't approach the little lady from the left, you might startle her.")
	dialogueOptions.push_back("I know she's not little anymore, but she'll always be a hatchling in my eyes.")
	
	#specialDialogue.push_back("If you want to slay that dragon, you're going to need some equipment.")
	#specialDialogue.push_back("I have a piece of ferrite that I could turn into a dagger for you.")
	#specialDialogue.push_back("When you open the forge, there will be a ? button that will give you information.")
	#specialDialogue.push_back("Click on the anvil to get started.")
	#specialDialogue.push_back("If you're ready to collet better materials, click on the map in the top left.")


func _process(delta):
	# fades out text box if necessary
	if !active or (!inBlacksmith and !inTextBox):
		dialogue.modulate.a = move_toward(dialogue.modulate.a,0,.5*delta)
	

# trigger dialogue when clicked
func _on_button_down():
	if !active:
		return
		
	dialogue.modulate.a = 1
	if specialDialogue.is_empty():
		dialogue.text = dialogueOptions.pick_random()
	else:
		dialogue.text = specialDialogue.front()
		specialDialogue.remove_at(0);

# dialogue fade/reapear based on mouse overlap
func _on_mouse_entered():
	if !active:
		return
	inBlacksmith = true
	if dialogue.modulate.a >0:
		dialogue.modulate.a = 1

func _on_mouse_exited():
	if !active:
		return
	inBlacksmith = false

func _on_backdrop_mouse_entered():
	if !active:
		return
	inTextBox = true
	if dialogue.modulate.a >0:
		dialogue.modulate.a = 1

func _on_backdrop_mouse_exited():
	if !active:
		return
	inTextBox = false
