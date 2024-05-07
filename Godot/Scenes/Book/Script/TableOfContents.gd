extends Node2D
@export var headers:Array

signal go_to_page(page)

# Called when the node enters the scene tree for the first time.
func _ready():
	var y = 0
	for arr in headers:
		for val in arr:
			var but = Button.new()
			$Text.add_child(but)
			but.position = Vector2(0,y*50)
			but.size.x = 444
			but.alignment = 0
			but.text_overrun_behavior = 1
			but.flat = true
			but.theme = load("res://Themes/UIButton.tres")
			but.button_down.connect(clicked.bind(y*4))
			if val != arr[0]:
				but.text = "     "
			else:
				but.text = ""
			but.text += val + " ..................................................."
			
			var page = Label.new()
			add_child(page)
			page.position = Vector2(410, y*50)
			page.size.x = 34
			page.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
			page.label_settings = load("res://Themes/BodyLabel.tres")
			page.text = str(y)
			
			but.mouse_entered.connect(mouse_over.bind(page, true))
			but.mouse_exited.connect(mouse_over.bind(page, false))
			y+=1
		
	
func mouse_over(obj, state):
	if state:
		obj.modulate.a = 72/255.0
	else:
		obj.modulate.a = 1
	
func clicked(page):
	emit_signal("go_to_page",page)
