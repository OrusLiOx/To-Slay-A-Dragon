extends Node2D
@export var dir:int
@export var noteScene :PackedScene
@export var isBlock : bool
var speed:float
var input
var color : Color

var good:Array
var ok:Array

signal hit(crit)

# Called when the node enters the scene tree for the first time.
func _ready():
	$Goal/Goal/Arrow.rotation = dir*PI/2
	match dir:
		0:
			$Goal/Goal/Letter.text = "A"
			input = "Left"
		1:
			$Goal/Goal/Letter.text = "W"
			input = "Up"
		2:
			$Goal/Goal/Letter.text = "D"
			input = "Right"
		3:
			$Goal/Goal/Letter.text = "S"
			input = "Down"
	reset()
	pass # Replace with function body.

func reset():
	for child in $Notes.get_children():
		child.queue_free()
		good.clear()
		ok.clear()
		
	if isBlock:
		color = Settings.get_note_color("block")
	else:
		color = Settings.get_note_color("attack")
	
	
	$Goal/Goal.modulate = Color(1,1,1,.4)
	$Goal/Goal/Arrow.modulate = color
	$Goal/Goal/Letter.modulate = color
	
	if Settings.noteType == "letter":
		$Goal/Goal/Arrow.visible = false
		$Goal/Goal/Letter.visible = true
	elif Settings.noteType == "arrow":
		$Goal/Goal/Arrow.texture = load("res://Sprites/UI/arrowFull.png")
		$Goal/Goal/Letter.visible = false
		$Goal/Goal/Arrow.visible = true
		$Goal/Goal/Arrow.position = Vector2(0,0)
	else:
		$Goal/Goal/Arrow.texture = load("res://Sprites/UI/arrow.png")
		$Goal/Goal/Letter.visible = true
		$Goal/Goal/Arrow.visible = true
		
		match dir:
			0:
				$Goal/Goal/Arrow.position = Vector2(-18,0)
			1:
				$Goal/Goal/Arrow.position = Vector2(0,-12)
			2:
				$Goal/Goal/Arrow.position = Vector2(18,0)
			3:
				$Goal/Goal/Arrow.position = Vector2(0,12)

func spawn_note():
	var note = noteScene.instantiate()
	note.dir = dir
	note.position = Vector2(0, 0)
	note.modulate = color
	note.go(speed)
	$Notes.add_child(note)
	return note

func _process(_delta):
	if Input.is_action_just_released(input):
		$Goal/Goal.modulate = Color(1,1,1,.4)
	if Input.is_action_just_pressed(input):
		$Goal/Goal.modulate = Color(1,1,1,.7)
		if !ok.is_empty():
			if good.find(ok.front()) == -1:
				ok.front().queue_free()
				emit_signal("hit","ok")
				Stats.goodNotes += 1
			else:
				good.front().queue_free()
				emit_signal("hit","good")
				Stats.greatNotes += 1
		else:
			emit_signal("hit", "wrong")

func _on_kill_area_entered(area):
	if area.is_in_group("Note"):
		emit_signal("hit", "miss")
		Stats.missedNotes += 1
	area.queue_free()

func _on_ok_area_entered(area):
	if area.is_in_group("Note"):
		ok.push_back(area)

func _on_ok_area_exited(area):
	if area.is_in_group("Note"):
		ok.pop_front()

func _on_good_area_entered(area):
	if area.is_in_group("Note"):
		good.push_back(area)

func _on_good_area_exited(area):
	if area.is_in_group("Note"):
		good.pop_front()
