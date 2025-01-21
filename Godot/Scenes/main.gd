extends Node2D
var camp
var map
var toCamp
var toMap

var blackout
var blackoutActive

# Called when the node enters the scene tree for the first time.
func _ready():
	$Map.visible = false

	$Book.open(5)

func _on_camp_to_map():
	$Map.visible = true


