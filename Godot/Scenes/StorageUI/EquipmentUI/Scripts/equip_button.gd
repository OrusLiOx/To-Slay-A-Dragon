extends Button
var equipment : Equipment

func set_equip(equip:Equipment):
	equipment = equip
	update()

func update():
	$EquipmentSprite.set_equip(equipment)
	
func set_ghost(type):
	equipment = null
	$EquipmentSprite.set_ghost(type)
