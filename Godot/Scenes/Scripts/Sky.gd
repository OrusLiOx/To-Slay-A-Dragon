extends Node2D

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
			
		if scale.x == 1:
			sky.position.y = 2*((moon.global_position.y-global_position.y)+381) - 850
		else:
			sky.position.y = 2*((moon.global_position.y-global_position.y)+381) - 850
			
	pass

func turn(incr = 1):
	if incr <=0:
		return
	Stats.totaltime += incr
	moving = true
	angleDest += incr*PI/3
	pass
