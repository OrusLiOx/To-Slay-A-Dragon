extends Node2D

signal use(part:Part)
signal use_equip(index)

func update():
	$MaterialStorage.update()

func _on_material_storage_use(part):
	emit_signal("use",part)
	pass # Replace with function body.

