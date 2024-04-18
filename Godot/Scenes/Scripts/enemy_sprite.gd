extends Sprite2D
var stats : Enemy
var flash 
var flashSpeed

func _ready():
	flash = 0
	flashSpeed = 10

func _process(delta):
	match(flash):
		1:
			modulate.b -= flashSpeed*delta
			modulate.g -= flashSpeed*delta
			if modulate.b <.05:
				flash = -1
				modulate.b = 0
				modulate.g = 0
		-1:
			modulate.b += flashSpeed*delta
			modulate.g += flashSpeed*delta
			if modulate.b >.95:
				flash = 0
				modulate.b = 1
				modulate.g = 1

func make_enemy(t:String):
	stats = Enemy.new(t)

func set_enemy(e : Enemy ):
	stats = e

func hit():
	flash = 1
