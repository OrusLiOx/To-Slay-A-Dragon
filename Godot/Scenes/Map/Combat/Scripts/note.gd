extends Area2D
var speed
var dir
var active

func _ready():
	active = false

func go(s):
	$Sprite2D.rotation = dir*PI/2
	match dir:
		0:
			$Label.text = "A"
			$Sprite2D.position = Vector2(-18,0)
		1:
			$Label.text = "W"
			$Sprite2D.position = Vector2(0,-12)
		2:
			$Label.text = "D"
			$Sprite2D.position = Vector2(18,0)
		3:
			$Label.text = "S"
			$Sprite2D.position = Vector2(0,12)
	speed = s


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.y += speed*delta
	pass
