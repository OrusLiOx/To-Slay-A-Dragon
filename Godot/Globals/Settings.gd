extends Node
var defaultAttackColor = "a60000"
var defaultBlockColor = "2953b5"

var noteSpeed : float

var noteColorAttack : Color
var noteColorBlock : Color
var noteType : String # mixed, letter, arrow
var noteSyncBar : String # multi, all. none
var noteMax:int

var infiniteParts


# Called when the node enters the scene tree for the first time.
func _ready():
	set_to_default()

func set_to_default():
	noteSpeed = 300
	noteMax = 3
	
	noteColorAttack = Color(defaultAttackColor)
	noteColorBlock = Color(defaultBlockColor)

	noteType = "mixed"
	noteSyncBar = "none"
	
func get_note_color(type):
	if type == "block":
		return noteColorBlock
	else:
		return noteColorAttack
