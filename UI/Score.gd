extends Label

onready var time = 0

func _physics_process(delta):
	text = "Score: " + str(Global.score)
	var Player = get_node_or_null('/root/Game/Player')
	if Player != null:
		time += delta
		var mils = fmod(time,1)*1000
		var secs = fmod(time,60)
		var mins = fmod(time,60*60) / 60
		var time_passed = "%02d : %02d . %03d" % [mins,secs, mils]
		text = "Score: " + str(Global.score) + "\nMed kits: " + str(len(Player.inventory)) +"\nTime: "+time_passed
		Global.time_string = time_passed
	
