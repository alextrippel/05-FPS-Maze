extends KinematicBody

onready var Camera = $Pivot/Camera

var gravity = -30
var max_speed = 9
var mouse_sensitivity = 0.002
var mouse_range = 1.2
var grounded = true
var velocity = Vector3()

onready var rc = $Pivot/RayCast
onready var flash = $Pivot/blaster/Flash
onready var Decal = preload('res://Player/Decal.tscn')

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$Pivot/Camera.current = true

func get_input():
	var input_dir = Vector3()
	if Input.is_action_pressed("forward"):
		input_dir += -Camera.global_transform.basis.z
	if Input.is_action_pressed("back"):
		input_dir += Camera.global_transform.basis.z
	if Input.is_action_pressed("left"):
		input_dir += -Camera.global_transform.basis.x
	if Input.is_action_pressed("right"):
		input_dir += Camera.global_transform.basis.x
	input_dir = input_dir.normalized()
	return input_dir

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		$Pivot.rotate_x(-event.relative.y * mouse_sensitivity)
		rotate_y(-event.relative.x * mouse_sensitivity)
		$Pivot.rotation.x = clamp($Pivot.rotation.x, -mouse_range, mouse_range)

func _physics_process(delta):
	velocity.y += gravity * delta
	var desired_velocity = get_input() * max_speed
	
	velocity.x = desired_velocity.x
	velocity.z = desired_velocity.z
	velocity = move_and_slide(velocity, Vector3.UP, true)
	if is_on_floor():
		grounded = true
	
	if Input.is_action_pressed('shoot') and !flash.visible:
		flash.shoot()
		if rc.is_colliding():
			var c = rc.get_collider()
			if c.is_in_group('Boom'):
				Global.score += 50
				c.explode()
			else:
				var decal = Decal.instance()
				rc.get_collider().add_child(decal)
				decal.global_transform.origin = rc.get_collision_point()
				decal.look_at(rc.get_collision_point() + rc.get_collision_normal(), Vector3.UP)
				if c.is_in_group('Enemy'):
					Global.score += 20
					c.queue_free()
			


func _on_ExplCheck_area_entered(area):
	if area.get_parent().is_in_group('Boom'):
		var _scene = get_tree().change_scene('res://UI/Lose2.tscn')