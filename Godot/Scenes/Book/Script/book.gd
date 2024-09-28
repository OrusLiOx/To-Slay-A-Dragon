extends Node2D
var curPage = 0
var enemyInfo:Dictionary
var start:Dictionary
var length
var maxPage
@export var pageBuffer:int

signal close_book()

# Called when the node enters the scene tree for the first time.
func _ready():
	length = {
		"info": 28,
		"settings":2,
		"help":6
	}
	start = {
		"info": pageBuffer,
		"settings":pageBuffer,
		"help":pageBuffer
	}
	var order = ["help","settings","info"]
	
	for i in order.size():
		for j in range(i+1,order.size()):
			start[order[j]]+= length[order[i]]

	maxPage = pageBuffer
	for value in length.values():
		maxPage+=value
	maxPage-=1
	
	# region/enemy info stuff
	enemyInfo["Quest"] = $EnemyInfo/QuestPage
	enemyInfo["Region"] = $EnemyInfo/RegionTitlePage
	enemyInfo["Map"] = $EnemyInfo/MapTitlePage
	$EnemyInfo/MapTitlePage/Buttons.pageNumStart = start["info"]
	$EnemyInfo/RegionTitlePage/Creatures/Forest.pageNumStart = start["info"]+2
	$EnemyInfo/RegionTitlePage/Creatures/Desert.pageNumStart = start["info"]+10
	$EnemyInfo/RegionTitlePage/Creatures/Mountain.pageNumStart = start["info"]+18
	$EnemyInfo/MapTitlePage/Buttons.update()
	$EnemyInfo/RegionTitlePage/Creatures/Forest.update()
	$EnemyInfo/RegionTitlePage/Creatures/Desert.update()
	$EnemyInfo/RegionTitlePage/Creatures/Mountain.update()
	
	# tutorial/help stuff
	$Help/Introduction/Contents.pageNumStart = start["help"]
	$Help/Introduction/Contents.update()
	
	# main table of contents
	var arr:Array[int]
	for key in order:
		arr.push_back(start[key])
	$TitlePage/TableOfContents.pageNums = arr
	$TitlePage/TableOfContents.pageNumStart = 1
	$TitlePage/TableOfContents.update()
	pageBuffer -=1
	update_page(1)
	pass # Replace with function body.

func update_page(newPage):
	# clean page number
	newPage = min(max(newPage,1),maxPage)
	if newPage%2 == 0:
		newPage-=1
	# set visual page number 
	$UI/PageNumL.text = str(newPage)
	$UI/PageNumR.text = str(newPage+1)
	
	# if page number is unchanged, return
	if newPage == curPage:
		return
	
	curPage = newPage
	
	# hide all
	enemyInfo["Quest"].visible = false
	enemyInfo["Region"].visible = false
	enemyInfo["Map"].visible = false
	$TitlePage.visible = false
	$Help.visible = false
	$Settings.visible = false
	$EnemyInfo.visible = false
	
	# title page
	if curPage == 1:
		$TitlePage.visible = true
	# Enemy Info page
	elif newPage>=start["info"] and newPage < start["info"]+length["info"]:
		$EnemyInfo.visible = true
		newPage -=start["info"]
		# Map page
		if newPage == 0:
			enemyInfo["Map"].visible = true
		# Region page
		elif (newPage-2)%8 == 0 and newPage <= 18:
			enemyInfo["Region"].visible = true
			match newPage/8:
				0:
					enemyInfo["Region"].set_region("Forest")
				1:
					enemyInfo["Region"].set_region("Desert")
				2:
					enemyInfo["Region"].set_region("Mountain")
		# Enemy page
		else:
			enemyInfo["Quest"].visible = true
			match newPage-4:
				0:
					enemyInfo["Quest"].set_page(Enemy.new("Goblin"))
				2:
					enemyInfo["Quest"].set_page(Enemy.new("Serpent"))
				4:
					enemyInfo["Quest"].set_page(Enemy.new("Fairy"))
				8:
					enemyInfo["Quest"].set_page(Enemy.new("Gold Beetle"))
				10:
					enemyInfo["Quest"].set_page(Enemy.new("Magma Lizard"))
				12:
					enemyInfo["Quest"].set_page(Enemy.new("Fire Spirit"))
				16:
					enemyInfo["Quest"].set_page(Enemy.new("Animated Armor"))
				18:
					enemyInfo["Quest"].set_page(Enemy.new("Wyvern"))
				20:
					enemyInfo["Quest"].set_page(Enemy.new("Mimic"))
				22:
					enemyInfo["Quest"].set_page(Enemy.new("Dragon"))
	elif newPage>=start["help"] and newPage < start["help"]+length["help"]:
		$Help.visible = true
		$Help.toPage(curPage-start["help"])
	elif newPage>=start["settings"] and newPage < start["settings"]+length["settings"]:
		$Settings.visible = true
	pass
	 
func _on_left_button_down():
	update_page(curPage-2)
	pass # Replace with function body.

func _on_right_button_down():
	update_page(curPage+2)
	pass # Replace with function body.

func open():
	visible = true
	update_page(curPage)

func exit():
	visible = false
	emit_signal("close_book")
	pass # Replace with function body.
