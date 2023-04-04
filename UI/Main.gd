extends Control

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if $Label != null:
		$Label.text += "Score: " + str(Global.score)

func _on_Play_pressed():
	var _scene = get_tree().change_scene('res://Game.tscn')
	Global.score = 0
	Global.health = 100


func _on_Quit_pressed():
	get_tree().quit()
