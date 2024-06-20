extends Area2D
var speed =0
@export var dir:int
var active

func _ready():
	active = false

func go(s):
	match(Settings.noteType):
		"letter":
			$Arrow.visible = false
			$Label.visible = true
			match dir:
				0:
					$Label.text = "A"
				1:
					$Label.text = "W"
				2:
					$Label.text = "D"
				3:
					$Label.text = "S"
		"arrow":
			$Arrow.texture = load("res://Sprites/UI/arrowFull.png")
			$Label.visible = false
			$Arrow.visible = true
		_:
			$Arrow.texture = load("res://Sprites/UI/arrow.png")
			$Arrow.visible = true
			$Label.visible = true
			match dir:
				0:
					$Label.text = "A"
					$Arrow.position = Vector2(-18,0)
				1:
					$Label.text = "W"
					$Arrow.position = Vector2(0,-12)
				2:
					$Label.text = "D"
					$Arrow.position = Vector2(18,0)
				3:
					$Label.text = "S"
					$Arrow.position = Vector2(0,12)
	$Arrow.rotation = dir*PI/2
	speed = s

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.y += speed*delta
	pass
