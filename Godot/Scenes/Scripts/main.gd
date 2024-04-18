extends Node2D
var camp
var map
var toCamp
var toMap

# Called when the node enters the scene tree for the first time.
func _ready():
	camp = $Camp
	map = $Map
	
	_on_map_to_camp()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_camp_to_map():
	map.position = Vector2(0,0)
	camp.position = Vector2(0,2000)
	pass # Replace with function body.


func _on_map_to_camp():
	camp.open()
	camp.position = Vector2(0,0)
	map.position = Vector2(0,2000)
	pass # Replace with function body.
