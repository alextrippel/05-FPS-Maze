extends TextureProgress


func _physics_process(_delta):
	if value > Global.health:
		value -= 1
	if value < Global.health:
		value += 1
