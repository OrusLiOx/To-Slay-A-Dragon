extends Node2D
var tabs :Array

signal use(part:Part)
signal use_equip(index)

# Called when the node enters the scene tree for the first time.
func _ready():
	tabs.push_back($MaterialStorage)
	tabs.push_back($EquipmentStorage)
	tabs.push_back($Material)
	tabs.push_back($Equipment)
	pass # Replace with function body.

func update():
	tabs[0].update()
	tabs[1].update()

func set_tab(tab):
	update()
	tabs[tab].set_active(true)
	tabs[tab+2].modulate.a = 1
	
	tab += 1
	tab %=2
	tabs[tab].set_active(false)
	tabs[tab+2].modulate.a = .5

func _on_material_button_down():
	set_tab(0)

func _on_equipment_button_down():
	set_tab(1)

func _on_material_storage_use(part):
	emit_signal("use",part)
	pass # Replace with function body.

func _on_equipment_storage_use_equip(index):
	emit_signal("use_equip", index)
	pass # Replace with function body.
