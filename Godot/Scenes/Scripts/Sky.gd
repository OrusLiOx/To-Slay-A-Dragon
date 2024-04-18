extends Node2D

@export var camp : Node2D
@export var map : Node2D

var moving

var sun
var moon
var sky

var angle

# Called when the node enters the scene tree for the first time.
func _ready():
	moving = false
	angle = 0
	sun = $Sun
	moon = $Moon
	sky = $Sky

	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("Blueprint1"):
		turn_night()
	if Input.is_action_just_pressed("Blueprint2"):
		turn_day()
	if moving:
		if abs(rotation - angle) <.01:
			moving = false
			return
			
		self.rotation = move_toward(self.rotation, angle, 1*delta)
		var percent = pow(abs(sin(rotation)),4)
		
		#sun.position.y = percent*-421 -388 
		#moon.position.y = percent*408 +400 
		
		if moon.global_position.y < 200:
			var c = 1-((moon.global_position.y-200)/-600 *.373)
			camp.modulate = Color(c,c,c)
			map.modulate = Color(c,c,c)
		else:
			camp.modulate = Color(1,1,1)
			map.modulate = Color(1,1,1)
			
	pass

func turn_night():
	moving = true
	angle = PI
	rotation = 0
	print(str(rotation)+ " " + str(angle))
	pass

func turn_day():
	moving = true
	rotation = PI
	angle = 2*PI
	print(str(rotation)+ " " + str(angle))
	pass
