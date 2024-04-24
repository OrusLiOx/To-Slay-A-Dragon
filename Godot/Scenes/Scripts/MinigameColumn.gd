extends Node2D
@export var dir:int
@export var noteScene :PackedScene
var speed:float
var input

var good:Array
var ok:Array

signal hit(crit)

# Called when the node enters the scene tree for the first time.
func _ready():
	$Goal/Goal/Arrow.rotation = dir*PI/2
	match dir:
		0:
			$Goal/Goal/Letter.text = "A"
			$Goal/Goal/Arrow.position = Vector2(-18,0)
			input = "Left"
		1:
			$Goal/Goal/Letter.text = "W"
			$Goal/Goal/Arrow.position = Vector2(0,-12)
			input = "Up"
		2:
			$Goal/Goal/Letter.text = "D"
			$Goal/Goal/Arrow.position = Vector2(18,0)
			input = "Right"
		3:
			$Goal/Goal/Letter.text = "S"
			$Goal/Goal/Arrow.position = Vector2(0,12)
			input = "Down"
	reset()
	pass # Replace with function body.

func reset():
	for child in $Notes.get_children():
		child.queue_free()
		good.clear()
		ok.clear()
	pass

func spawn_note():
	var note = noteScene.instantiate()
	note.dir = dir
	note.position = Vector2(0,-300)
	note.go(speed)
	$Notes.add_child(note)

func _process(delta):
	if Input.is_action_just_pressed(input):
		if !ok.is_empty():
			if good.find(ok.front()) == -1:
				ok.front().queue_free()
				emit_signal("hit","ok")
			else:
				good.front().queue_free()
				emit_signal("hit","good")
		else:
			emit_signal("hit", "wrong")

func _on_kill_area_entered(area):
	if area.is_in_group("Note"):
		emit_signal("hit", "miss")
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
