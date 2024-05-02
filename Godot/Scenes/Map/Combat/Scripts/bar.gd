extends Sprite2D
var notes : Array
var speed :float

func _process(delta):
	position.y += speed*delta
	var remove = true
	for note in notes:
		if note != null:
			remove = false
			break
	if remove:
		self.queue_free()
