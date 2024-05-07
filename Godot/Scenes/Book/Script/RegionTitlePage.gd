extends Node2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func set_region(region):
	$Title.text = region
	$Map.texture = load("res://Sprites/book/"+region+"Edit.png") 
	match region:
		"Forest":
			$Creatures/Forest.visible = true
			$Creatures/Desert.visible = false
			$Creatures/Mountain.visible = false
			$Description.text = "Forest description"
		"Desert":
			$Creatures/Forest.visible = false
			$Creatures/Desert.visible = true
			$Creatures/Mountain.visible = false
			$Description.text = "Desert description"
		"Mountain":
			$Creatures/Forest.visible = false
			$Creatures/Desert.visible = false
			$Creatures/Mountain.visible = true 
			$Description.text = "Mountain description"
	pass
