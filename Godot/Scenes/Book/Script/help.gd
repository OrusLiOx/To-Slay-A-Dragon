extends Node2D
signal go_to_page(page)
var sectionStart:Array

func _ready():
	sectionStart = $Introduction/Contents.pageNums
	sectionStart = sectionStart.duplicate()
	for i in sectionStart.size():
		if sectionStart[i]%2 != 0:
			sectionStart[i]-=1
	print(sectionStart)


func _on_contents_go_to_page(page):
	emit_signal("go_to_page",page)

func toPage(page):
	# find section number
	var section:int = 0
	while section < 3 and sectionStart[section] <= page :
		section+=1
	section-=1
	
	var objs:Array = get_children()

	for i in objs.size():
		objs[i].visible = i == section
		
	# specific page
	if objs[section].name == "Introduction":
		return
	page -= sectionStart[section]
	page/=2
	var pages = objs[section].get_children()

	for i in pages.size():
		pages[i].visible = i==page

