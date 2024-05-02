extends Node

var noteSpeed : float

var noteColorDefault :Color
var noteColorAttack : Color
var noteColorBlock : Color
var noteColorOff :bool
var noteColorSwap :bool
var noteType : String
var noteSyncBar : String


# Called when the node enters the scene tree for the first time.
func _ready():
	set_to_default()
	
	pass # Replace with function body.

func set_to_default():
	noteSpeed = 300
	
	noteColorDefault = Color(1,1,1)
	noteColorAttack = Color("a60000")
	noteColorBlock = Color("2953b5")
	noteColorSwap = false
	noteColorOff = true
	noteType = "mixed"
	noteSyncBar = "multi"
	

func get_note_color(type):
	if noteColorOff:
		return noteColorDefault
	
	if type == "block":
		if noteColorSwap:
			return noteColorAttack
		else:
			return noteColorBlock
	else:
		if noteColorSwap:
			return noteColorBlock 
		else:
			return noteColorAttack
