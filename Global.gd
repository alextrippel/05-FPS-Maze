extends Node

var menu = null
const SAVE_PATH = "res://settings.cfg"
var save_file = ConfigFile.new()
var inputs = ["left","right","forward","back"]
onready var cross = null

var which_player = 0
var player2id = -1

func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS
	load_input()

func _unhandled_input(_event):
	if Input.is_action_just_pressed('menu'):
		if menu == null:
			menu = get_node_or_null('/root/Game/UI/Menu')
		if menu != null:
			if not menu.visible:
				cross = get_node_or_null('/root/Game/UI/Crosshair')
				cross.hide()
				get_tree().paused = true
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
				menu.show()
			else:
				save_input()
				get_tree().paused = false
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
				menu.hide()
				cross = get_node_or_null('/root/Game/UI/Crosshair')
				cross.show()

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
