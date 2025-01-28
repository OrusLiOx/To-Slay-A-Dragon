extends Node2D
var curPage = -1
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
		"help":10
	}
	start = {
		"info": pageBuffer,
		"settings":pageBuffer,
		"help":pageBuffer
	}
	var order = ["settings","help","info"]
	
	for i in order.size():
		for j in range(i+1,order.size()):
			start[order[j]]+= length[order[i]]

	maxPage = pageBuffer
	for value in length.values():
		maxPage+=value
	maxPage-=2
	
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
	var heads:Array[Array] = [["Settings"],
		["Tutorial","Introduction", "Combat","Forging"],
		["Creatures & Resgions","Forest", "Desert","Mountains"]]
	$TitlePage/TableOfContents.headers = heads

	
	var arr:Array[int] = []
	
	arr.push_back(start["settings"])
	
	arr.push_back(start["help"])
	for i in $Help/Introduction/Contents.pageNums:
		arr.push_back(i+start["help"])
	
	arr.push_back(start["info"])
	for i in [2,10,18]:
		arr.push_back(i+start["info"])

	$TitlePage/TableOfContents.pageNums = arr
	$TitlePage/TableOfContents.update()
	pageBuffer -= 1

func update_page(newPage:int):
	var lastPage = maxPage+2
	# clean page number
	newPage = min(max(newPage,-1),lastPage)
	if newPage%2 == 0:
		newPage-=1
	# set visual page number 
	$UI/PageNumL.text = str(newPage)
	$UI/PageNumR.text = str(newPage+1)
	
	# if page number is unchanged, return
	if newPage == curPage:
		if curPage <= 0 or curPage >= lastPage:
			Audio.play("CloseBook")
		else:
			Audio.play("OpenBook")
		return
	
	if curPage <= 0 or curPage >= lastPage:
		# was on cover
		open_book()
	elif !(newPage <= 0 or newPage >= lastPage):
		# inner page to inner page
		Audio.play("PageFlip")
	
	if curPage == 1:
		$BookBase/Home.visible = true
	
	curPage = newPage
	if curPage <= 0:
		show_book_cover("front")
		return
	if curPage >= lastPage:
		show_book_cover("back")
		return

	hide_all()
	
	# title page
	if curPage == 1:
		$TitlePage.visible = true
		$BookBase/Home.visible = false
	# Enemy Info page
	elif newPage>=start["info"] and newPage < start["info"]+length["info"]:
		$EnemyInfo.visible = true
		newPage -= start["info"]
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
		elif newPage <= maxPage:
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
	
func show_book_cover(side:String, pageSound = true):
	hide_all()
	if pageSound:
		Audio.play("CloseBook")
	$UI/PageNumL.visible = false
	$UI/PageNumR.visible = false
	
	if side == "front":
		$BookBase.visible = false
		$Back.visible = false
		$Front.visible = true
		$UI/Left.visible = false
	else:
		$BookBase.visible = false
		$Front.visible = false
		$Back.visible = true
		$UI/Right.visible = false

func open_book(pageSound = true):
	if pageSound:
		Audio.play("OpenBook")
	$UI/PageNumL.visible = true
	$UI/PageNumR.visible = true
	
	$BookBase.visible = true
	$Front.visible = false
	$Back.visible = false
	
	$UI/Left.visible = true
	$UI/Right.visible = true

func hide_all():
	enemyInfo["Quest"].visible = false
	enemyInfo["Region"].visible = false
	enemyInfo["Map"].visible = false
	$TitlePage.visible = false
	$Help.visible = false
	$Settings.visible = false
	$EnemyInfo.visible = false

func _on_left_pressed():
	update_page(curPage-2)

func _on_right_pressed():
	update_page(curPage+2)

func open(page = -1):
	if page == -1:
		page = curPage
	update_page(page)
	visible = true

func close():
	Audio.play("CloseBook")
	visible = false
	emit_signal("close_book")

func _on_home_pressed():
	update_page(1)
