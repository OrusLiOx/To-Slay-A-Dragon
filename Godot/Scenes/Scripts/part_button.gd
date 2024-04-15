extends Button

var part : Part

signal use(part:Part)

func make_part(type, rarity):
	set_part(Part.new(type,rarity))

func set_part(p):
	part = p
	if p.rarity == -2:
		disabled = true
		visible = false
	else:
		visible = true
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
	emit_signal("use",part)
	update()
	pass # Replace with function body.

