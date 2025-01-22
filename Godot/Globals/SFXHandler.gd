extends Node

@export var maxSounds:int = 5
var sounds: Dictionary = {
	"OpenBook":load("res://Sounds/page-flip1.mp3"),
	"PageFlip":load("res://Sounds/page-flip2.mp3"),
	"CloseBook":load("res://Sounds/close-book.mp3"),
}
var i = 0

func _ready():
	for n in range(maxSounds):
		add_child(AudioStreamPlayer.new())

func play(sound, jitter = true):
	return
	if !sounds.has(sound):
		push_error("Error: no sound effect of name " + sound + " found")
		return
	var player:AudioStreamPlayer = get_child(i)
	i = (i+1)%maxSounds
	player.stream = sounds[sound]
	if jitter:
		player.set_pitch_scale(randf_range(.9,1.1))
	else:
		player.set_pitch_scale(1)
	player.play()
	pass
