extends Node

var time
var combatTime

var deaths
var forfeits
var wins

var greatNotes
var goodNotes
var missedNotes

# Called when the node enters the scene tree for the first time.
func _ready():
	reset()

func reset():
	time = 0
	combatTime = 0
	
	deaths = 0
	forfeits = 0
	wins = 0

	greatNotes = 0
	goodNotes = 0
	missedNotes = 0

func time_to_string(total:int):
	var hours:int = total/3600000
	total %= 3600000
	var min:int = total/60000
	total %= 60000
	var sec:float = total/1000.0
	
	min %= 60
	
	var timeString = ""
	if hours != 0:
		timeString += str(hours) +":"
		if min < 9:
			timeString += "0"
	
	timeString += str(min) +":"
	if sec < 9:
		timeString += "0"
	timeString += str(sec)
	return(timeString)

func time_stats_to_string():
	var text = ""
	text += "Total Time: " + time_to_string(time) + "\n"
	text += "Time in Combat: " + time_to_string(combatTime) + "\n"
	return text

func combat_stats_to_string():
	var text = ""
	text += "Total Combats: " + str(deaths+forfeits+wins) + "\n"
	text += "Wins: " + str(wins) + "\n"
	text += "Deaths: " + str(deaths) + "\n"
	text += "Forfeits: " + str(forfeits) + "\n"
	return text

func note_stats_to_string():
	var text = ""
	text += "Total Notes: " + str(greatNotes+goodNotes+missedNotes) + "\n"
	text += "Perfect: " + str(greatNotes) + "\n"
	text += "Okay: " + str(goodNotes) + "\n"
	text += "Miss: " + str(missedNotes) + "\n"
	return text

func stats_to_string():
	var text = ""
	text += time_stats_to_string() + "\n"
	text += combat_stats_to_string() + "\n"
	text += note_stats_to_string() + "\n"
	return text
