extends KinematicBody

var Player = null
onready var dying = false

func _physics_process(_delta):
	if not dying:
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
	if body.name == "Player" and not dying:
		body.damage(25, "Enemy")

func death():
	dying = true
	$Tween.interpolate_property($Spatial, 'rotation_degrees', Vector3(0,180,0), Vector3(-90,180,0), 0.5, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	$Tween.start()


func _on_Tween_tween_all_completed():
	queue_free()
