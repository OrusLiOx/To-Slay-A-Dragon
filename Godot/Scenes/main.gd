extends Node2D

func _ready():
	
	Input.set_custom_mouse_cursor(load("res://Sprites/UI/mousePointer.png"),2)
	
	$AudioStreamPlayer.play()
	$Map.visible = false
	$Camp.visible = true
	$Book.visible = true
	$Book.open(5)


func _on_camp_to_map():
	$Map.visible = true

func _on_camp_open_book():
	$Book.open()

func _on_audio_stream_player_finished():
	$AudioStreamPlayer.play()
