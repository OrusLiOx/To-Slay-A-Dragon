extends Button
var glow:Sprite2D
@export var glowSprite:Texture

func _ready():
	if glowSprite == null:
		queue_free()
		return
	glow = $Glow
	glow.visible = false
	glow.position.x = size.x/2
	glow.position.y = size.y/2
	glow.set_texture(glowSprite)
	
func _on_mouse_entered():
	glow.visible = true

func _on_mouse_exited():
	glow.visible = false
