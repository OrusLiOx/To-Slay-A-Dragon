extends Node2D

@export var camp : Node2D
@export var map : Node2D

var moving

var bodies
var sun
var moon
var sky

var curAngle
var angleDest

# Called when the node enters the scene tree for the first time.
func _ready():
	moving = false
	curAngle = 0
	angleDest = 0
	bodies = $Bodies
	sun = $Bodies/Sun
	moon = $Bodies/Moon
	sky = $Sky

	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("Blueprint1"):
		turn()
	if moving:
		bodies.rotate(3*delta)
		curAngle += 3*delta
		
		if curAngle >= angleDest:
			moving = false
			while angleDest >= 2*PI:
				angleDest -= 2*PI
			bodies.rotation = angleDest
			curAngle = bodies.rotation
			return
		
		var percent = pow(abs(sin(bodies.rotation)),4)
		#sun.position.y = percent*-421 -388 
		#moon.position.y = percent*408 +400 
		sky.position.y = 2*(moon.global_position.y+381) - 850
		
		#if moon.global_position.y < 200:
			#var c = 1-((moon.global_position.y-200)/-600 *.373)
			#camp.modulate = Color(c,c,c)
			#map.modulate = Color(c,c,c)
		#else:
			#camp.modulate = Color(1,1,1)
			#map.modulate = Color(1,1,1)
			
	pass

func turn(incr = 1):
	if incr <=0:
		return
	Stats.totaltime+=incr
	moving = true
	angleDest += incr*PI/3
	pass
