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
			$Description.text = "The forest is the perfect place for novice adventures to start their journey. The region has a temperate climate and it's pretty easy to find something to eat in case you underpack. The creatures in this region don't tend to attack unless you get too close and they're pretty easy to run away from if necessary."
		"Desert":
			$Creatures/Forest.visible = false
			$Creatures/Desert.visible = true
			$Creatures/Mountain.visible = false
			$Description.text = "If you're looking for more of a challenge, the desert is the place to go. Most creatures in this region only come out at night to avoid the heat. I would advise that you do the same."
		"Mountain":
			$Creatures/Forest.visible = false
			$Creatures/Desert.visible = false
			$Creatures/Mountain.visible = true 
			$Description.text = "The mountains are where most adventurers go in search of glory and wealth. The terrain is treacherous, and the creatures in the region are very powerful. Since it's so dangerous, almost everything you can find there is valuable. Even seemingly mundane items can be of interest to researchers."
