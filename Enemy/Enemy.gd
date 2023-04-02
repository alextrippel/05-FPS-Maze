extends KinematicBody

var Player = null

func _physics_process(_delta):
	Player = get_node_or_null('/root/Game/Player')
	if Player != null:
		look_at(Player.global_transform.origin, Vector3.UP)
		rotation_degrees.x = 0


func _on_Sound_body_entered(body):
	if body.name == "Player":
		var sound = get_node_or_null('/root/Game/Zombie')
		if sound != null and not sound.playing:
			sound.playing = true


func _on_Kill_body_entered(body):
	if body.name == "Player":
		var _scene = get_tree().change_scene('res://UI/Lose.tscn')
