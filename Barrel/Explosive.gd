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
	if body.is_in_group("Boom") and !exploding and body.name != self.name:
		body.explode()
	if body.name == 'Player' and body.exploded == false:
		body.velocity.y += 15
		body.damage(75, "Explosive")
		body.exploded = true
		#var _scene = get_tree().change_scene('res://UI/Lose2.tscn')


func _on_Tween_tween_all_completed():
	var player = get_node_or_null('/root/Game/Player')
	player.exploded = false
	get_parent().queue_free()
