extends Node2D
signal go_to_page(page)
var sectionStart

func _ready():
	sectionStart = $Introduction/Contents.pageNums
	for i in sectionStart.size():
		if sectionStart[i]%2 != 0:
			sectionStart[i]-=1

func _on_contents_go_to_page(page):
	emit_signal("go_to_page",page)

func toPage(page):
	var objs:Array = get_children()
	var cur
	var found = false
	for i in objs.size():
		objs[i].visible = false
		if !found and page < sectionStart[i]:
			objs[i-1].visible = true
			page -= sectionStart[i-1]
			cur = objs[i-1]
			found = true
	
	if !found:
		objs[3].visible = true
		page -= sectionStart[3]
		cur = objs[3]
			
	page/=2
	if cur.name == "Introduction" or cur.name == "ButtonGuide":
		return
	objs = cur.get_children()
	for i in objs.size():
		objs[i].visible = page == i
	
