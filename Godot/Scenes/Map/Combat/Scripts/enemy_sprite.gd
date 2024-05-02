extends Sprite2D
var stats : Enemy
var flash 
var flashSpeed
@export var background : Sprite2D

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
	set_enemy(Enemy.new(t))

func set_enemy(e : Enemy ):
	stats = e
	match(e.type):
		"Goblin":
			texture = load("res://Sprites/Enemies/goblin.png")
			set_background("res://Sprites/Enemies/forest.png")
		"Serpent":
			texture = load("res://Sprites/Enemies/snake.png")
			set_background("res://Sprites/Enemies/forest.png")
		"Fairy":
			texture = load("res://Sprites/Enemies/fairy.png")
			set_background("res://Sprites/Enemies/forest.png")
		
		
		"Gold Beetle":
			texture = load("res://Sprites/Enemies/beetle.png")
			set_background("res://Sprites/Enemies/desert.png")
		"Magma Lizard":
			texture = load("res://Sprites/Enemies/lizard.png")
			set_background("res://Sprites/Enemies/desert.png")
		"Fire Spirit":
			texture = load("res://Sprites/Enemies/fox.png")
			set_background("res://Sprites/Enemies/desert.png")
			
		"Animated Armor":
			texture = load("res://Sprites/Enemies/armor.png")
			set_background("res://Sprites/Enemies/cave.png")
		"Wyvern":
			texture = load("res://icon.svg")
			set_background("res://Sprites/Enemies/cave.png")
		"Chest":
			texture = load("res://Sprites/Enemies/chest.png")
			set_background("res://Sprites/Enemies/cave.png")
		"Mimic":
			texture = load("res://Sprites/Enemies/mimic.png")
			set_background("res://Sprites/Enemies/cave.png")
		
		"Dragon":
			texture = load("res://icon.svg")
			set_background("res://Sprites/Enemies/mountain.png")

func set_background(path):
	if background != null:
		background.texture = load(path)

func hit():
	flash = 1
