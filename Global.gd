extends Node

var menu = null
const SAVE_PATH = "res://settings.cfg"
var save_file = ConfigFile.new()
var inputs = ["left","right","forward","back"]
onready var score = 0
onready var health = 100

func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS
	load_input()
	
	
func _unhandled_input(_event):
	if Input.is_action_just_pressed('menu'):
		if menu == null:
			menu = get_node_or_null('/root/Game/UI/Menu')
		if menu != null:
			if not menu.visible:
				var cross = get_node_or_null('/root/Game/UI/Crosshair')
				cross.hide()
				get_tree().paused = true
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
				menu.show()
			else:
				save_input()
				get_tree().paused = false
				var cross = get_node_or_null('/root/Game/UI/Crosshair')
				cross.show()
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
				menu.hide()

func load_input():
	var error = save_file.load(SAVE_PATH)
	if error != OK:
		print("Failed loading file")
		return
	
	for i in inputs:
		var key = save_file.get_value("Inputs", i, null)
		InputMap.action_erase_events(i)
		InputMap.action_add_event(i, key)

func save_input():
	for i in inputs:
		var actions = InputMap.get_action_list(i)
		for a in actions:
			save_file.set_value("Inputs", i, a)
	save_file.save(SAVE_PATH)

func die(cause):
	if cause == 'Explosive':
		var _scene = get_tree().change_scene('res://UI/Lose2.tscn')
	elif cause == "Enemy":
		var _scene = get_tree().change_scene('res://UI/Lose.tscn')
	else :
		var _scene = get_tree().change_scene('res://UI/Lose3.tscn')
