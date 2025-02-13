extends Node2D

func _ready():
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
