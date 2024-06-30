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
			edit.text = "At high temperatures, the plating on gold beetles can be melted down into a metal-like material known as Pyre's ore. Pyre's ore is difficult to obtain since gold beetles don't develop their plating until they reach adulthood. If you feel well prepared, you should definitely try to take one down. Pyre's ore is very strong and makes excellent weapons and armor."
		"Magma Lizard":
			drop = Part.new("s",1)
			edit.text = "Magma lizards are one of the closest living relatives of dragons. Like dragons, they have six limbs and can breathe fire. Unlike dragons, they tend to be very friendly when raised in captivity. They would probably be popular pets if they didn't need so much food and take up so much space. They'll also set your house on fire if they get too nervous."
		"Fire Spirit":
			drop = Part.new("f",1)
			edit.text = "Fire Spirits typically appear as trails of fire dancing across the ground. Most Fire Spirits will flee if you get too close, but some will take on fox-like forms and attack. Their speed can make them very dangerous, but they only take a few hits to defeat.\n\nNOTE: Water is not an effective weapon against them. Unless you can dump the entire ocean on them, this will only make them more angry."
			
		"Animated Armor":
			drop = Part.new("m",2)
			edit.text = "Long ago, our ancestors built temples to worship dragons and created guardians to protect and maintain the temples. Animated Armor was a very popular choice of guardian. An Animated Armor's creator can teach it commands, but for many temples, the words and phrases to command the armors have been lost to time. Technically, you can deactivate them by dispelling the magic that controls them, but that would prevent you from getting enchanted metal from them."
		"Wyvern":
			drop = Part.new("s",2)
			edit.text = "Wyverns were once thought to be baby dragons that would eventually metamorphosize into the brightly colored, fire breathing beasts that we all know and fear. Despite their similarities, wyverns aren't closely related to dragons. Since wyverns aren't as big or strong as dragons, some people will steal wyvern eggs thinking they'll be docile if raised in captivity. This is not true. No matter how you raise them, they will eventually see you as food."
		"Mimic":
			drop = Part.new("f",2)
			edit.text = "If a dreamer stone is left in an empty container for a week, the container will turn into a mimic. Mimics are suprisingly smart and can be kept as companions if you have the patience to train them. They're a lot like cats except they can bite your hand off and cast fireball."
		
		"Dragon":
			edit.text = "dragon text"
	
	edit = $Stats
	edit.text = "Attack: " + str(enemy.attack) + "\n"
	edit.text += "Health: " + str(enemy.maxHp) + "\n\n"	
	
	edit.text += "Drop: "
	if drop == null:
		edit.text+= "???\n"
	else:
		edit.text += drop.get_name() + "\n"
		edit.text += "Value: " + str(drop.get_value())
	
	edit = $Actions
	edit.text = ""
	
	edit.text +="Time Between Actions:\n"
	var mi = enemy.noteDelayMin
	var ma = enemy.noteDelayMax
	if mi != ma:
		edit.text += str(mi) + " - "
	edit.text += str(ma)+" s\n\n"
	
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
	
