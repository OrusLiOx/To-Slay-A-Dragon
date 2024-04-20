extends Node2D
var camp
var map
var toCamp
var toMap

var blackout
var blackoutActive

# Called when the node enters the scene tree for the first time.
func _ready():
	camp = $Camp
	map = $Map
	
	blackout = $Blackout
	blackout.visible = false
	blackoutActive = false
	
	_on_map_to_camp()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if blackoutActive:
		blackout.modulate.a = move_toward(blackout.modulate.a, 1, 5*delta)
	else:
		blackout.modulate.a = move_toward(blackout.modulate.a, 0, 2*delta)
	blackout.visible = blackout.modulate.a != 0
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


func _on_map_death():
	blackoutActive = true
	$Timer.start(1)
	pass # Replace with function body.

func _on_timer_timeout():
	_on_map_to_camp()
	$Timer.stop()
	$Sky.turn(3)
	map.finish_quest()
	blackoutActive = false
	pass # Replace with function body.

func _on_map_time():
	$Sky.turn()
	pass # Replace with function body.
