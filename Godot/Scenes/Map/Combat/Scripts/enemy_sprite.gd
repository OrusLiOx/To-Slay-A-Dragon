extends Node2D
var stats : Enemy
@export var background : Sprite2D
var sprite

func _ready():
	sprite = $Enemy

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
			load_enemy_sprite("mimic")
			
		"Dragon":
			load_enemy_sprite("dragon")

func load_enemy_sprite(type, shadow = true):
	sprite.texture = load("res://Sprites/Enemies/"+type+".png")
	if type == "mimic":
		background.texture = load("res://Sprites/Enemies/chestBackground.png")
	else:
		background.texture = load("res://Sprites/Enemies/"+type+"Background.png")
	if type == "fox":
		$Shadow.visible = false
		return
	$Shadow.visible = shadow
	$Shadow.texture = load("res://Sprites/Enemies/"+type+"Shadow.png")

func set_background(path):
	if background != null:
		background.texture = load(path)

func hit(crit = false):
	var to = .3
	var time = .2
	if crit:
		to = 0
		
	create_tween().tween_property(sprite, "modulate:g", to, time)
	create_tween().tween_property(sprite, "modulate:b", to, time)
	
	await get_tree().create_timer(time).timeout
	
	create_tween().tween_property(sprite, "modulate:g", 1, time)
	create_tween().tween_property(sprite, "modulate:b", 1, time)
