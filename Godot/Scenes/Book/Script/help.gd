extends Node2D
signal go_to_page(page)

func _on_contents_go_to_page(page):
	emit_signal("go_to_page",page)

func toPage(page):
	$Introduction.visible =  page == 0

	$Forge.visible = page == 2
	
	$Combat.visible = page == 4
	
