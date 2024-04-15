extends Sprite2D

func set_part(part):
	var f
	match(part.type):
		"m":
			f = 0
		"f":
			f = 3
		"s":
			f = 6
			
	if part.rarity < 0:
		self.frame = f+2
		$Shine.frame = f+2
	else:
		self.frame = f
		$Shine.frame = f+1

	self.self_modulate = part.get_color()
