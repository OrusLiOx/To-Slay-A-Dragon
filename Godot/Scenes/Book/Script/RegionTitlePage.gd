extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func set_region(region):
	$Title.text = region
	$Map.texture = load("res://Sprites/Map/"+region+"Edit.png") 
	match region:
		"Forest":
			$Map.texture = load("res://Sprites/Map/ForestEdit.png") 
		"Desert":
			$Map.texture = load("res://Sprites/Map/ForestEdit.png") 
		"Mountain":
			$Map.texture = load("res://Sprites/Map/ForestEdit.png") 
	pass
