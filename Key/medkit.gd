extends Spatial

func _on_Area_body_entered(body):
	if body.name == 'Player':
		body.inventory.append('medkit')
		queue_free()

