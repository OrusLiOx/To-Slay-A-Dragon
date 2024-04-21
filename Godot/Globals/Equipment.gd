class_name Equipment

var type : String
var parts : Array
var value : float

func _init(name :String = "" , p : Array = []):
	craft(name, p)	

func craft(t:String, p : Array):
	type = t
	parts = p
	
	value = 0
	for part in parts:
		value += part.get_value()
	
	pass

func is_weapon():
	return !type.contains("armor")
