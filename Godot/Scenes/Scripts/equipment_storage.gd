extends Node2D
@export var equipButScene: PackedScene
@export var matButScene: PackedScene

var page
var pageSize

var armorDisplay
var weaponDisplay

var curArmor : Equipment
var curWeapon : Equipment

# Called when the node enters the scene tree for the first time.
func _ready():
	pageSize = 9
	armorDisplay = $Equipped/Armor
	weaponDisplay = $Equipped/Weapon
	
	armorDisplay.mouse_entered.connect(set_item_display.bind(true,armorDisplay))
	armorDisplay.mouse_exited.connect(set_item_display.bind(false,armorDisplay))
	weaponDisplay.mouse_entered.connect(set_item_display.bind(true,weaponDisplay))
	weaponDisplay.mouse_exited.connect(set_item_display.bind(false,weaponDisplay))
	
	generate_inv()
	load_page(0)
	load_current()
	pass # Replace with function body.
	
func update():
	load_page(page)
	load_current()

func load_current():
	var attack = 0
	var defense = 0
	
	if Storage.curArmor != -1:
		curArmor = Storage.equipment[Storage.curArmor]
		defense = curArmor.value
		armorDisplay.set_equip(curArmor)
	else:
		armorDisplay.set_ghost("med armor")
	
	if Storage.curWeapon != -1:
		curWeapon = Storage.equipment[Storage.curWeapon]
		attack = curWeapon.value
		weaponDisplay.set_equip(curWeapon)
	else:
		weaponDisplay.set_ghost("sword")
		
	$Equipped/Stats.text = "Attack: " + str(attack) +"\nDefense: " + str(defense)

func generate_inv():
	var parent = $Main/Buttons
	
	for i in range(0, pageSize):
		var child = equipButScene.instantiate()
		parent.add_child(child)
		child.position.x = (i%3)*125
		child.position.y = (i/3)*125
			
		child.mouse_entered.connect(set_item_display.bind(true,child))
		child.mouse_exited.connect(set_item_display.bind(false,child))
		
		child.button_down.connect(equip.bind(i))
		
func load_page(p):
	page = p

	var cond = page > 0
	$Main/Left.visible = cond
	$Main/Left.disabled = !cond
	
	cond = Storage.equipment.size() > (page+1)*pageSize
	
	$Main/Right.visible = cond
	$Main/Right.disabled = !cond
	
	var parent = $Main/Buttons
	var start = page*pageSize
	
	for i in range(0, pageSize):
		var child = parent.get_child(i)
		
		# set equipment
		if start+i >= Storage.equipment.size():
			child.set_equip(null)
			child.update()
			child.disabled = true
		else:
			child.set_equip(Storage.equipment[start+i])
			child.update()
			child.disabled = false
		
			# is equiped?
			if start+i == Storage.curArmor or start+i == Storage.curWeapon:
				child.get_child(1).text = "E"
			else:
				child.get_child(1).text = ""
	
func set_item_display(vis:bool, obj):
	var e
	if obj == armorDisplay:
		e = curArmor
	elif obj == weaponDisplay:
		e = curWeapon
	else:
		e = obj.equipment
		
	if e == null:
		return
	$Main/PartDisplay.visible = vis
	
	if vis:
		if e.is_weapon():
			$Main/PartDisplay/Label.text = "Attack: " + str(e.value)
		else:
			$Main/PartDisplay/Label.text = "Defense: " + str(e.value)
		
		var x = 0
		var y = 0
		var parent = $Main/PartDisplay/Parts
		
		for part in e.parts:
			var child = matButScene.instantiate()
			child.set_part(part)
			parent.add_child(child)
			child.position.x = x
			child.position.y = y
			child.disabled = true
			
			if x < 250:
				x += 125
			else:
				x = 0
				y+=125
	else:
		for child in $Main/PartDisplay/Parts.get_children():
			child.queue_free()

func equip(index):
	index = page*9+index
	Storage.set_cur_equip(index)
	load_current()
	load_page(page)

func set_active(state):
	$Main.visible = state
		
func _on_left_button_down():
	load_page(page-1)
	pass # Replace with function body.

func _on_right_button_down():
	load_page(page+1)
	pass # Replace with function body.
