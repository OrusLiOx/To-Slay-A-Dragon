extends Button

@export var part :String
@export var enemy : String
@export var dataDisplayPosition : Vector2
var questMaterial : Part
var questEnemy :Enemy

signal show_quest_data(quest)
signal hide_quest_data()

func _ready():
	questMaterial = Part.new(part[0],int(part[1]))
	questEnemy = Enemy.new(enemy)
