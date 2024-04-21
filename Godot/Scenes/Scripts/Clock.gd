extends Node2D

var moving

var curAngle
var angleDest

signal done()
# Called when the node enters the scene tree for the first time.
func _ready():
	moving = false
	curAngle = 0
	angleDest = 0

	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if moving:
		rotate(3*delta)
		curAngle += 3*delta
		
		if curAngle >= angleDest:
			moving = false
			emit_signal("done")
			while angleDest >= 2*PI:
				angleDest -= 2*PI
			rotation = angleDest
			curAngle = rotation
			return
		
	pass

func turn(incr = 1):
	if incr <=0:
		return
	moving = true
	angleDest += incr*PI/3
	pass
