extends Button

var part : Part

signal use(part:Part)

func make_part(type, rarity):
	part = Part.new()
	part.type = type
	part.rarity = rarity
	$PartSprite.set_part(part)

func set_part(p):
	part = p
	$PartSprite.set_part(part)

func update():
	var amount = Storage.parts[part.type][part.rarity]
	$Quantity.text = str(amount)
	
	if amount == 0 :
		disabled = true
		$PartSprite.modulate.a = .3
		$Quantity.modulate.a = .3
	else:
		disabled = false
		$PartSprite.modulate.a = 1
		$Quantity.modulate.a = 1

func _on_button_down():
	Storage.add_part(part, -1)
	emit_signal("use",part)
	update()
	pass # Replace with function body.

