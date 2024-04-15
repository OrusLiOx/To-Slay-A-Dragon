extends Button
var equipment : Equipment

func set_equip(equip:Equipment):
	equipment = equip
	update()
	pass

func update():
	$EquipmentSprite.set_equip(equipment)
	pass
