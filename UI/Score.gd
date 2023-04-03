extends Label


func _physics_process(_delta):
	text = "Score: " + str(Global.score)
