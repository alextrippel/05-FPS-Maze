extends KinematicBody

onready var Camera = $Pivot/Camera

var gravity = -30
var max_speed = 9
var mouse_sensitivity = 0.002
var mouse_range = 1.2
var grounded = true
var velocity = Vector3()
var exploded = false
var safe = true
var inventory = []
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
	if Input.is_action_pressed("jump"):
		if grounded :
			jump()
	if Input.is_action_just_pressed('heal'):
		if 'medkit' in inventory:
			Global.health = 100
			inventory.remove('medkit')
	input_dir = input_dir.normalized()
	return input_dir

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		$Pivot.rotate_x(-event.relative.y * mouse_sensitivity)
		rotate_y(-event.relative.x * mouse_sensitivity)
		$Pivot.rotation.x = clamp($Pivot.rotation.x, -mouse_range, mouse_range)

func _physics_process(delta):
	if Global.health > 100:
		Global.health = 100
	velocity.y += gravity * delta
	var desired_velocity = get_input() * max_speed
	velocity.x = desired_velocity.x
	velocity.z = desired_velocity.z
	velocity = move_and_slide(velocity, Vector3.UP, true)
	if is_on_floor():
		grounded = true
	if translation.y > 2.2 :
		safe = false
		damage(5*delta, 'sky')
	else:
		safe = true
	if translation.y < -2.5 :
		damage(101, 'sky')
	if Input.is_action_pressed('shoot') and !flash.visible:
		flash.shoot()
		playershoot()
		
func playershoot():
	if rc.is_colliding():
		var c = rc.get_collider()
		var p = $Pivot/RayCast.get_collision_point()
		if c.is_in_group('Boom'):
			if not c.exploding:
				Global.score += 50
				c.explode()
		elif c.is_in_group('Enemy'):
				if not c.dying:
					Global.score += 20
					c.death()
		elif c.is_in_group('Wood'):
			var hole = CSGSphere.new()
			hole.radius = .75
			hole.operation = CSGShape.OPERATION_SUBTRACTION
			c.add_child(hole)
			hole.global_translation = p
			if c.get_child_count() > 8:
				c.queue_free()
				Global.score += 10
		else:
			if not c.is_in_group('health'):
				var decal = Decal.instance()
				rc.get_collider().add_child(decal)
				decal.global_transform.origin = rc.get_collision_point()
				if decal.global_transform.origin.y < 2.4 :
					decal.look_at(rc.get_collision_point() + rc.get_collision_normal(), Vector3.UP)
				

func jump():
	velocity.y += 8
	grounded = false	

func damage(d, cause):
	Global.health -= d
	if Global.health <= 0:
		Global.die(cause)


func _on_Timer_timeout():
	if Global.health < 100 and safe == true:
		Global.health += 1
