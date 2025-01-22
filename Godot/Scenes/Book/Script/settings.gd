extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	$Gameplay/Gameplay/SymbolSelect/Mixed.button_pressed  = true
	update_symbol_display()

func set_note_colors(choice:String):
	match choice:
		"none":
			Settings.noteColorOff = true
		"normal":
			Settings.noteColorOff = false
			Settings.noteColorSwap = false
		"swap":
			Settings.noteColorOff = false
			Settings.noteColorSwap = true
	update_symbol_display()

func set_note_symbols(choice):
	Settings.noteType = choice
	update_symbol_display()

func update_symbol_display():
	var notes = $Gameplay/Gameplay/Demo.get_children()
	match Settings.noteType:
		"letter":
			notes[0].position.x = 0
			notes[1].position.x = 100
			notes[2].position.x = 200
			notes[3].position.x = 300
		"arrow":
			notes[0].position.x = -20
			notes[1].position.x = 92.5
			notes[2].position.x = 207.5
			notes[3].position.x = 320
		_:
			notes[0].position.x = 0
			notes[1].position.x = 95
			notes[2].position.x = 205
			notes[3].position.x = 300
	
	for note in notes:
		note.position.x += 118
		note.go(0)
	notes[0].go(0)
	notes[1].go(0)
	notes[2].go(0)
	notes[3].go(0)
	
	notes[0].modulate = Settings.get_note_color("block")
	notes[1].modulate = Settings.get_note_color("attack")
	notes[2].modulate = Settings.get_note_color("attack")
	notes[3].modulate = Settings.get_note_color("block")
