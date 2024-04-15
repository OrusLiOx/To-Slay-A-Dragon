extends Node2D
var tabs :Array

signal use(part:Part)

# Called when the node enters the scene tree for the first time.
func _ready():
	tabs.push_back($MaterialStorage)
	tabs.push_back($EquipmentStorage)
	tabs.push_back($Material)
	tabs.push_back($Equipment)
	pass # Replace with function body.

func set_tab(tab):
	tabs[tab].visible = true
	tabs[tab+2].modulate.a = 1
	
	tab += 1
	tab %=2
	tabs[tab].visible = false
	tabs[tab+2].modulate.a = .5


func _on_material_button_down():
	set_tab(0)


func _on_equipment_button_down():
	set_tab(1)


func _on_material_storage_use(part):
	emit_signal("use",part)
	pass # Replace with function body.
