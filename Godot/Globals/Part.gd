class_name Part

var type : String
var rarity : int 

func _init(arg1 = "" , arg2 : int = -1):
	if arg1 == "":
		set_vals("m",0)
	elif arg2 == -1:
		set_vals(arg1.type, arg1.rarity)
	else:
		set_vals(arg1,arg2)
	
func set_vals(t :String , r : int):
	type = t
	rarity = r

func get_value():
	var base = (rarity+1)*10
	match(type):
		"m":
			return base
		"f":
			return base*1.5
		"s":
			return base*1.25

func get_color():
	match(type):
		"m":
			match(rarity):
				0: 
					return Color(1,1,1)
				1: 
					return Color(1,0,0)
				2: 
					return Color(0,1,0)
				3: 
					return Color(0,0,1)
		"f":
			match(rarity):
				0: 
					return Color(1,1,1)
				1: 
					return Color(1,0,0)
				2: 
					return Color(0,1,0)
				3: 
					return Color(0,0,1)
		"s":
			match(rarity):
				0: 
					return Color(1,1,1)
				1: 
					return Color(1,0,0)
				2: 
					return Color(0,1,0)
				3: 
					return Color(0,0,1)
	return Color(.5,.5,.5);

func get_name():
	match(type):
		"m":
			match(rarity):
				0: 
					return "common metal"
				1: 
					return "uncommon metal"
				2: 
					return "rare metal"
				3: 
					return "legendary metal"
				4: 
					return "dragon metal"
		"f":
			match(rarity):
				0: 
					return "common focus"
				1: 
					return "uncommon focus"
				2: 
					return "rare focus"
				3: 
					return "legendary focus"
				4: 
					return "dragon focus"
		"s":
			match(rarity):
				0: 
					return "common focus"
				1: 
					return "uncommon focus"
				2: 
					return "rare focus"
				3: 
					return "legendary focus"
				4: 
					return "dragon focus"
