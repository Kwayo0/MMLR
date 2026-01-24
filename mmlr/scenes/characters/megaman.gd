extends CharacterBody3D

@onready var head = $Head
@onready var camera = $Head/Camera3D
@onready var megaman = $Megaman

var camera_x_rotation = 0
var paused = false
var pos = Vector3()
var zoom = 0
var v_at_jump = Vector2(0,0)

const mouse_sensitivity = 0.1
var movement_speed = 1.75
const gravity = 3.5
const jump_velocity = 1.7*1.5
const rotspeed = .2

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	head.position.y = camera_x_rotation/200 + .25

func _input(event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_SHIFT):
		movement_speed = 5
	if Input.is_action_just_pressed("pause"):
		paused = not paused
		if paused:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	if paused:
		return
	
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_WHEEL_UP:
		if zoom > -7:
			zoom -= 1
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
		if zoom < 7:
			zoom += 1
	
	if event is InputEventMouseMotion:
		head.rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))
		var delta_x = event.relative.y * mouse_sensitivity
		if camera_x_rotation + delta_x > -30 and camera_x_rotation + delta_x < 30:
			camera.rotate_x(deg_to_rad(-delta_x))
			camera_x_rotation += delta_x
		head.position.y = camera_x_rotation/200 + .25
		camera.fov = max(75,75+camera_x_rotation/10) + zoom

func _physics_process(delta: float) -> void:
	if paused:
		return
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and """is_on_floor()""":
		velocity.y = jump_velocity
		v_at_jump = Vector2(0,0)
	
	var direction = Vector3()
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var pressed_direction = false
	var offset = 0
	
	if Input.is_action_pressed("ui_down"):
		direction += head.basis.z
		pressed_direction = true
	if Input.is_action_pressed("ui_left"):
		direction -= head.basis.x
		offset = PI/2.0
		pressed_direction = true
	if Input.is_action_pressed("ui_right"):
		direction += head.basis.x
		offset = -PI/2.0
		pressed_direction = true
	if Input.is_action_pressed("ui_up"):
		direction -= head.basis.z
		pressed_direction = true
		offset /= 2
	if pressed_direction:
		rotate_megaman(offset)
	
	if !is_on_floor():
		var norm = Vector2(velocity.x,velocity.z)
		velocity.z += direction.z * movement_speed / 40
		velocity.x += direction.x * movement_speed / 40
		if norm.length() > movement_speed:
			norm = norm.normalized() * movement_speed
			velocity.z = norm.y
			velocity.x = norm.x
		
	else:
		velocity.z = direction.z * movement_speed
		velocity.x = direction.x * movement_speed
	pos = position
	move_and_slide()
	
	

func rotate_megaman(offset = 0.0):
	if !is_on_floor():
		return
	if offset:
		megaman.rotation.y = head.rotation.y+offset
		return
	if sign(megaman.rotation.y) != sign(head.rotation.y) and abs(megaman.rotation.y-head.rotation.y) > PI:
		megaman.rotate_y(sign(megaman.rotation.y)*rotspeed)
	else:
		megaman.rotate_y(sign(head.rotation.y-megaman.rotation.y)*rotspeed)
	if abs(megaman.rotation.y-head.rotation.y) < rotspeed:
		megaman.rotation.y = head.rotation.y
