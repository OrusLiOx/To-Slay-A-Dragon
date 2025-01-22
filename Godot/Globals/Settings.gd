extends Node

var noteSpeed : float

var noteColorDefault :Color
var noteColorAttack : Color
var noteColorBlock : Color
var noteColorOff :bool 
var noteColorSwap :bool
var noteType : String # mixed, letter, arrow
var noteSyncBar : String # multi, all. none
var infiniteParts


# Called when the node enters the scene tree for the first time.
func _ready():
	set_to_default()
	
	pass # Replace with function body.

func set_to_default():
	noteSpeed = 300
	
	noteColorAttack = Color("a60000")
	noteColorBlock = Color("2953b5")

	noteType = "mixed"
	noteSyncBar = "none"
	
func get_note_color(type):
	if type == "block":
		return noteColorBlock
	else:
		return noteColorAttack
