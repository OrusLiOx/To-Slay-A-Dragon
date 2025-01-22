extends TextureRect
enum ACTION {ATTACK,BLOCK}
@export var action:ACTION

func _ready():
	if action == ACTION.BLOCK:
		texture.region = Rect2(Vector2i(100, 0), Vector2i(100, 100))
	_on_visibility_changed()

func _on_visibility_changed():
	if action == ACTION.ATTACK:
		modulate = Settings.noteColorAttack
	else:
		modulate = Settings.noteColorBlock
