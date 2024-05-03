extends Node2D
var stats : Enemy
var flash 
var flashSpeed
@export var background : Sprite2D
var sprite

func _ready():
	flash = 0
	flashSpeed = 10
	sprite = $Enemy

func _process(delta):
	match(flash):
		1:
			sprite.modulate.b -= flashSpeed*delta
			sprite.modulate.g -= flashSpeed*delta
			if sprite.modulate.b <.05:
				flash = -1
				sprite.modulate.b = 0
				sprite.modulate.g = 0
		-1:
			sprite.modulate.b += flashSpeed*delta
			sprite.modulate.g += flashSpeed*delta
			if sprite.modulate.b >.95:
				flash = 0
				sprite.modulate.b = 1
				sprite.modulate.g = 1

func make_enemy(t:String):
	set_enemy(Enemy.new(t))

func set_enemy(e : Enemy ):
	stats = e
	match(e.type):
		"Goblin":
			load_enemy_sprite("goblin")
			set_background("res://Sprites/Enemies/forest.png")
		"Serpent":
			load_enemy_sprite("snake")
			set_background("res://Sprites/Enemies/forest.png")
		"Fairy":
			load_enemy_sprite("fairy")
			set_background("res://Sprites/Enemies/forest.png")
		
		
		"Gold Beetle":
			load_enemy_sprite("beetle")
			set_background("res://Sprites/Enemies/desert.png")
		"Magma Lizard":
			load_enemy_sprite("lizard")
			set_background("res://Sprites/Enemies/desert.png")
		"Fire Spirit":
			load_enemy_sprite("fox")
			set_background("res://Sprites/Enemies/desert.png")
			
		"Animated Armor":
			load_enemy_sprite("armor")
			set_background("res://Sprites/Enemies/cave.png")
		"Wyvern":
			load_enemy_sprite("wyvern")
			set_background("res://Sprites/Enemies/cave.png")
		"Chest":
			load_enemy_sprite("chest")
			set_background("res://Sprites/Enemies/cave.png")
		"Mimic":
			load_enemy_sprite("mimic")
			set_background("res://Sprites/Enemies/cave.png")
		
		"Dragon":
			sprite.texture = load("res://icon.svg")
			set_background("res://Sprites/Enemies/mountain.png")

func load_enemy_sprite(type, shadow = true):
	sprite.texture = load("res://Sprites/Enemies/"+type+".png")
	if type == "fox" or type == "lizard":
		return
	$Shadow.texture = load("res://Sprites/Enemies/"+type+"Shadow.png")

func set_background(path):
	if background != null:
		background.texture = load(path)

func hit():
	flash = 1
