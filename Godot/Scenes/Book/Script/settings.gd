extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	$Gameplay/Colors/Normal.button_pressed  = true
	$Gameplay/Symbols/Mixed.button_pressed  = true
	update_symbol_display()
	pass # Replace with function body.

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
	match Settings.noteType:
		"letter":
			$Gameplay/Demo/Note.position.x = 0
			$Gameplay/Demo/Note2.position.x = 100
			$Gameplay/Demo/Note3.position.x = 200
			$Gameplay/Demo/Note4.position.x = 300
		"arrow":
			$Gameplay/Demo/Note.position.x = -20
			$Gameplay/Demo/Note2.position.x = 92.5
			$Gameplay/Demo/Note3.position.x = 207.5
			$Gameplay/Demo/Note4.position.x = 320
		_:
			$Gameplay/Demo/Note.position.x = 0
			$Gameplay/Demo/Note2.position.x = 95
			$Gameplay/Demo/Note3.position.x = 205
			$Gameplay/Demo/Note4.position.x = 300
			
	$Gameplay/Demo/Note.go(0)
	$Gameplay/Demo/Note2.go(0)
	$Gameplay/Demo/Note3.go(0)
	$Gameplay/Demo/Note4.go(0)
	
	$Gameplay/Demo/Note.modulate = Settings.get_note_color("block")
	$Gameplay/Demo/Note2.modulate = Settings.get_note_color("attack")
	$Gameplay/Demo/Note3.modulate = Settings.get_note_color("attack")
	$Gameplay/Demo/Note4.modulate = Settings.get_note_color("block")
