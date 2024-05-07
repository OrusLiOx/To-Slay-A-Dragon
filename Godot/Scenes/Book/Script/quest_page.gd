extends Node2D


# Called when the node enters the scene tree for the first time.
func set_page(enemy:Enemy):
	$Sprite2D/Enemy/EnemySprite.set_enemy(enemy)
	$Area.text = enemy.type
	var edit = $Flavor
	var drop:Part
	match enemy.type:
		"Goblin":
			drop = Part.new("m",0)
			edit.text = "Goblin text"
		"Serpent":
			drop = Part.new("s",0)
			edit.text = "serpent text"
		"Fairy":
			drop = Part.new("f",0)
			edit.text = "fairy text"
		
		"Gold Beetle":
			drop = Part.new("m",1)
			edit.text = "beetle text"
		"Magma Lizard":
			drop = Part.new("s",1)
			edit.text = "lizard text"
		"Fire Spirit":
			drop = Part.new("f",1)
			edit.text = "fire text"
			
		"Animated Armor":
			drop = Part.new("m",2)
			edit.text = "armor text"
		"Wyvern":
			drop = Part.new("s",2)
			edit.text = "wyvern text"
		"Mimic":
			drop = Part.new("f",2)
			edit.text = "mimic text"
		
		"Dragon":
			edit.text = "dragon text"
	
	edit = $Stats
	edit.text = "Attack: " + str(enemy.attack) + "\n"
	edit.text += "Defense: " + str(enemy.defense) + "\n"
	edit.text += "Health: " + str(enemy.maxHp) + "\n\n"	
	
	edit.text += "Drop: "
	if drop == null:
		edit.text+= "???\n"
	else:
		edit.text += drop.get_name() + "\n"
		edit.text += "Value: " + str(drop.get_value())
	
	edit = $Actions
	edit.text = ""
	for key in enemy.weight.keys():
		match key:
			"attack":
				edit.text += "Opening: "
			"block":
				edit.text += "Attack: "
			"double block":
				edit.text += "Attack x2: "
			"attack block":
				edit.text += "Attack + Opening: "
			"attack double block":
				edit.text += "Attack x2 + Opening: "
		edit.text += str(enemy.weight[key]*100)+"%\n"
	edit.text +="\nTime Between Actions:\n"
	var min = enemy.noteDelayMin
	var max = enemy.noteDelayMax
	if min != max:
		edit.text += str(min) + " - "
	edit.text += str(max)+" s"
