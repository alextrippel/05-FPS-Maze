extends Spatial

onready var time = 1
onready var Kill = get_node("Kill/DeathShape")
onready var exploding = false

func explode():
	exploding = true
	$Glow.show()
	$Tween.interpolate_property($Kill, "scale", Vector3(1,1,1), Vector3(20,20,20), 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.interpolate_property($Visual, "radius", .2, 5, 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()

func _on_Kill_body_entered(body):
	if body.is_in_group("Enemy"):
		body.queue_free()
	if body.is_in_group("Boom") and !exploding and body != self:
		body.explode()
	if body.name == 'Player':
		var _scene = get_tree().change_scene('res://UI/Lose2.tscn')


func _on_Tween_tween_all_completed():
	get_parent().queue_free()
