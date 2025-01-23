extends Node

var time

var deaths
var forfeits
var wins

var greatNotes
var goodNotes
var missedNotes

# Called when the node enters the scene tree for the first time.
func _ready():
	time = 0
	
	deaths = 0
	forfeits = 0
	wins = 0

	greatNotes = 0
	goodNotes = 0
	missedNotes = 0
