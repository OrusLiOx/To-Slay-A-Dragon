class_name Part

var type : String
var rarity : int 

func _init(arg1 = "none" , arg2 : int = -100):
	if arg1 == "none":
		set_vals("m",0)
	elif arg2 == -100:
		set_vals(arg1.type, arg1.rarity)
	else:
		set_vals(arg1,arg2)
	
func set_vals(t :String , r : int):
	type = t
	rarity = r

func get_value():
	if rarity <0:
		return 0
	var base = (rarity+1)*10
	if type =="f":
		base+=5
	return base
	#match(type):
		#"m":
			#return base
		#"f":
			#return base*1.5
		#"s":
			#return base

func get_color():
	match(type):
		"m":
			match(rarity):
				0: 
					return Color(1,1,1)
				1: 
					return Color("ffe652")
				2: 
					return Color("b97cff")
				3: 
					return Color(0,1,1)
		"f":
			match(rarity):
				0: 
					return Color("ff61f2")
				1: 
					return Color("ff1200")
				2: 
					return Color("4373ff")
				3: 
					return Color(0,0,1)
		"s":
			match(rarity):
				0: 
					return Color("37a42a")
				1: 
					return Color("f28e20")
				2: 
					return Color("626262")
				3: 
					return Color(0,0,1)
	return Color(1,1,1)

func get_name():
	match(type):
		"m":
			match(rarity):
				0: 
					return "Ferrite"
				1: 
					return "Pyre's Ore"
				2: 
					return "Lilium"
				3: 
					return "legendary metal"
				4: 
					return "dragon metal"
		"f":
			match(rarity):
				0: 
					return "Fairy Heart"
				1: 
					return "Burning Core"
				2: 
					return "Dreamer Stone"
				3: 
					return "legendary focus"
				4: 
					return "dragon focus"
		"s":
			match(rarity):
				0: 
					return "Serpent Scale"
				1: 
					return "Lizard Scale"
				2: 
					return "Wyvern Scale"
				3: 
					return "legendary focus"
				4: 
					return "dragon focus"

func get_enemy():
	match type:
		"m":
			match rarity:
				0: return "goblin"
				1: return "gold beetle"
				2: return "animated armor"
		"f":
			match rarity:
				0: return "farie"
				1: return "fire spirit"
				2: return "chest"
		"s":
			match rarity:
				0: return "serpent"
				1: return "magma lizard"
				2: return "wyvren"
