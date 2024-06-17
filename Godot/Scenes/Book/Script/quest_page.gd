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
			edit.text = "Goblins typically live in small groups. They camp together and gather food together and many assume that attacking one goblin will cause the whole group to attack you. In reality, goblins are quite cowardly and will typically flee if a member of the group gets attacked."
		"Serpent":
			drop = Part.new("s",0)
			edit.text = "Serpents spend most of their time basking near rivers. When they're hungry, they dive into the water to hunt fish and other animals drinking from the river. They're pretty slow on land and don't pose much of a threat unless they manage to drag you underwater."
		"Fairy":
			drop = Part.new("f",0)
			edit.text = "Despite their name, the pink stones that fairies often leave behind are not their hearts. This should be obvious considering the stones are larger than a fairy's body and faries are immortal. Fairies consider fighting to be a form a play and they leave behind magical stones as gifts."
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
				edit.text += "Attack: "
			"block":
				edit.text += "Block: "
			"double block":
				edit.text += "Block x2: "
			"attack block":
				edit.text += "Attack + Block: "
			"attack double block":
				edit.text += "Block x2 + Attack: "
		edit.text += str(enemy.weight[key]*100)+"%\n"
	edit.text +="\nTime Between Actions:\n"
	var mi = enemy.noteDelayMin
	var ma = enemy.noteDelayMax
	if mi != ma:
		edit.text += str(mi) + " - "
	edit.text += str(ma)+" s"
