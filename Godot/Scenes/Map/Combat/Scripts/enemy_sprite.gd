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
		"Serpent":
			load_enemy_sprite("snake")
		"Fairy":
			load_enemy_sprite("fairy")
		
		
		"Gold Beetle":
			load_enemy_sprite("beetle")
		"Magma Lizard":
			load_enemy_sprite("lizard")
		"Fire Spirit":
			load_enemy_sprite("fox")
			
		"Animated Armor":
			load_enemy_sprite("armor")
		"Wyvern":
			load_enemy_sprite("wyvern")
		"Chest":
			load_enemy_sprite("chest")
		"Mimic":
			load_enemy_sprite("chest")
			sprite.texture = load("res://Sprites/Enemies/mimic.png")
		
		"Dragon":
			load_enemy_sprite("dragon")

func load_enemy_sprite(type, shadow = true):
	sprite.texture = load("res://Sprites/Enemies/"+type+".png")
	background.texture = load("res://Sprites/Enemies/"+type+"Background.png")
	if type == "fox":
		$Shadow.visible = false
		return
	$Shadow.visible = true
	$Shadow.texture = load("res://Sprites/Enemies/"+type+"Shadow.png")

func set_background(path):
	if background != null:
		background.texture = load(path)

func hit():
	flash = 1
