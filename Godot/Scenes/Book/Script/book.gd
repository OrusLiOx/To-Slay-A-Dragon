extends Node2D
var curPage = 0
@export var infoPageStart:int

# Called when the node enters the scene tree for the first time.
func _ready():
	$MapTitlePage/Buttons.pageNumStart = infoPageStart
	$RegionTitlePage/Creatures/Forest.pageNumStart = infoPageStart+2
	$RegionTitlePage/Creatures/Desert.pageNumStart = infoPageStart+10
	$RegionTitlePage/Creatures/Mountain.pageNumStart = infoPageStart+18
	$MapTitlePage/Buttons.update()
	$RegionTitlePage/Creatures/Forest.update()
	$RegionTitlePage/Creatures/Desert.update()
	$RegionTitlePage/Creatures/Mountain.update()
	
	update_page(1)
	pass # Replace with function body.


func update_page(newPage):
	newPage = min(max(newPage,1),30)
	if newPage%2 == 0:
		newPage-=1
		
	$UI/PageNumL.text = str(newPage)
	$UI/PageNumR.text = str(newPage+1)
	
	if newPage == curPage:
		return
	
	curPage = newPage

	if curPage>=infoPageStart and curPage < infoPageStart+28:
		if curPage == infoPageStart:
			$QuestPage.visible = false
			$RegionTitlePage.visible = false
			$MapTitlePage.visible = true
		elif (curPage-infoPageStart-2)%8 == 0 and curPage <= infoPageStart+18:
			$QuestPage.visible = false
			$RegionTitlePage.visible = true
			$MapTitlePage.visible = false
			match int(curPage-infoPageStart-2)/8:
				0:
					$RegionTitlePage.set_region("Forest")
				1:
					$RegionTitlePage.set_region("Desert")
				2:
					$RegionTitlePage.set_region("Mountain")
		else:
			$QuestPage.visible = true
			$RegionTitlePage.visible = false
			$MapTitlePage.visible = false
			match curPage-infoPageStart-4:
				0:
					$QuestPage.set_page(Enemy.new("Goblin"))
				2:
					$QuestPage.set_page(Enemy.new("Serpent"))
				4:
					$QuestPage.set_page(Enemy.new("Fairy"))
				8:
					$QuestPage.set_page(Enemy.new("Magma Lizard"))
				10:
					$QuestPage.set_page(Enemy.new("Gold Beetle"))
				12:
					$QuestPage.set_page(Enemy.new("Fire Spirit"))
				16:
					$QuestPage.set_page(Enemy.new("Animated Armor"))
				18:
					$QuestPage.set_page(Enemy.new("Mimic"))
				20:
					$QuestPage.set_page(Enemy.new("Wyvern"))
				22:
					$QuestPage.set_page(Enemy.new("Dragon"))
				
	pass
	
func _on_left_button_down():
	update_page(curPage-2)
	pass # Replace with function body.

func _on_right_button_down():
	update_page(curPage+2)
	pass # Replace with function body.
