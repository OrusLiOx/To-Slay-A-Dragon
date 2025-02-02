extends Node2D

func _ready():
	$Map.visible = false
	$Camp.visible = true
	$Book.visible = true
	$Book.open(5)


func _on_camp_to_map():
	$Map.visible = true

func _on_camp_open_book():
	$Book.open()
	
