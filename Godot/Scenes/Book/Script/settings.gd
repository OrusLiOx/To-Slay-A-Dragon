extends Node2D
var selectedAction:String
var LineEditRegEx = RegEx.new()

func _ready():
	$Gameplay/Gameplay/SymbolSelect/Mixed.button_pressed  = true
	$'Gameplay/Gameplay/MaxSelect/3'.button_pressed  = true
	%AttackColorRect.color = Settings.noteColorAttack
	%BlockColorRect.color = Settings.noteColorBlock
	
	LineEditRegEx.compile("^[0-9]*$")
	%MasterSlider.value = 70
	%MusicSlider.value = 70
	%SFXSlider.value = 70
	
	update_symbol_display()
	_on_attack_color_edit_pressed()

## SYMBOL SELECT ##
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

## COLOR EDIT ##
func _on_attack_color_edit_pressed():
	%AttackColorSelect.visible = true
	%BlockColorSelect.visible = false
	selectedAction = "attack"
	%ColorPicker.color = Settings.noteColorAttack

func _on_block_color_edit_pressed():
	%AttackColorSelect.visible = false
	%BlockColorSelect.visible = true
	selectedAction = "block"
	%ColorPicker.color = Settings.noteColorBlock

func _on_color_picker_color_changed(color):
	set_color(selectedAction, color)
	
func set_color(action, color:Color):
	var notes = $Gameplay/Gameplay/Demo.get_children()
	if action == "attack":
		%AttackColorRect.color = color
		Settings.noteColorAttack = color
		notes[1].modulate = color
		notes[2].modulate = color
		%AttackColorReset.visible = color.to_html(false) != Settings.defaultAttackColor
			
	else:
		%BlockColorRect.color = color
		Settings.noteColorBlock = color
		notes[0].modulate = color
		notes[3].modulate = color
		%BlockColorReset.visible = color.to_html(false) != Settings.defaultBlockColor

func _on_attack_color_rest_pressed():
	set_color("attack", Color(Settings.defaultAttackColor))

func _on_block_color_reset_pressed():
	set_color("block", Color(Settings.defaultBlockColor))

## MAX NOTES ##
func set_max(maximum:int):
	Settings.noteMax = maximum

func _on_infinite_health_toggled(toggled_on):
	Settings.infiniteHealth = toggled_on

func _on_infinite_damage_toggled(toggled_on):
	Settings.infiniteDamage = toggled_on

## VOLUME ##
func _volume_changed(value, bus):
	var decible = linear_to_db(float(value)/100.0)
	AudioServer.set_bus_volume_db(bus, decible)
