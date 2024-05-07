extends Node2D


# Called when the node enters the scene tree for the first time.
func set_page(enemy:Enemy):
	$Area.text = enemy.type
	var edit = $Flavor
	var drop:Part
	match enemy:
		"Goblin":
			drop = Part.new("m",1)
			edit = ""
		"Serpent":
			drop = Part.new("s",1)
			edit = ""
		"Fairy":
			drop = Part.new("f",1)
			edit = ""
		
		"Gold Beetle":
			drop = Part.new("m",2)
			edit = ""
		"Magma Lizard":
			drop = Part.new("s",2)
			edit = ""
		"Fire Spirit":
			drop = Part.new("f",2)
			edit = ""
			
		"Animated Armor":
			drop = Part.new("m",3)
			edit = ""
		"Wyvern":
			drop = Part.new("s",3)
			edit = ""
		"Mimic":
			drop = Part.new("f",3)
			edit = ""
		
		"Dragon":
			edit = ""
	
	edit = $Stats
	edit.text = "Attack: " + str(enemy.attack) + "\n"
	edit.text += "Defense: " + str(enemy.defense) + "\n"
	edit.text += "Health: " + str(enemy.maxHp) + "\n\n"	
	
	edit.text += "Drop: " + drop.get_name() + "\n"
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
				edit += "Opening: "
			"block":
				edit += "Attack: "
			"double block":
				edit += "Attack x2: "
			"attack block":
				edit += "Attack + Opening: "
			"attack double block":
				edit += "Attack x2 + Opening: "
		edit += str(enemy.weight[key]*100)+"%\n"
	edit +="\n\nTime Between Actions:\n"
	var min = enemy.noteDelayMin
	var max = enemy.noteDelayMax
	if min != max:
		edit += str(min) + " - "
	edit += str(max)+" s"
