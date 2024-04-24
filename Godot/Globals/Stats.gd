extends Node

var totaltime
var combats
var deaths
var accuracy

# Called when the node enters the scene tree for the first time.
func _ready():
	totaltime = 0
	combats = 0
	deaths = 0
	accuracy = Vector2(0,0)
	pass # Replace with function body.

func get_accuracy():
	return accuracy.x/accuracy.y
