extends Area2D
var speed
var dir

# Called when the node enters the scene tree for the first time.
func _ready():
	speed = 300
	dir = randi_range(0,3)
	$Sprite2D.rotation = dir*PI/2
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x -= speed*delta
	pass
