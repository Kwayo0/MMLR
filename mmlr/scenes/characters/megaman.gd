extends CharacterBody3D

@onready var head = $Head
@onready var camera = $Head/Camera3D
@onready var megaman = $Megaman
@export var marker: Node3D

var camera_x_rotation = 0
var paused = false
var pos = Vector3()
var zoom = 0
var v_at_jump = Vector2(0,0)
var frompos

var zooming = false
var locked = false
var locked_e

const mouse_sensitivity = 0.1
var movement_speed = 1.75
const gravity = 3.5
const jump_velocity = 1.7*1.5
const rotspeed = .2

var attack = 0
var energy = 0
var bRange = 0
var rapid = 0
var burst = (4+energy)%11-1

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	head.position.y = camera_x_rotation/200.0 + .25

func _input(event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_SHIFT):
		movement_speed = 5
	else:
		movement_speed = 1
	if Input.is_action_just_pressed("pause"):
		paused = not paused
		if paused:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	if paused:
		return
	
	if Input.is_action_just_pressed("lock"):
		$Head/Camera3D/Zoom.start()
	if Input.is_action_just_released("lock"):
		$Head/Camera3D/Zoom.stop()
		if !zooming and !locked:
			prioritize()
		elif !zooming and locked:
			locked = false
			marker.visible = false
		else:
			zooming = false
	if zooming and event is InputEventMouseMotion:
		if zoom >= -7 and zoom <= 7:
			zoom += Input.get_last_mouse_velocity().y/6000
		if zoom > 7:
			zoom = 7
		elif zoom < -7:
			zoom = -7
	
	if event is InputEventMouseMotion and !zooming and !locked:
		head.rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))
		var delta_x = event.relative.y * mouse_sensitivity
		if camera_x_rotation + delta_x > -30 and camera_x_rotation + delta_x < 30:
			camera.rotate_x(deg_to_rad(-delta_x))
			camera_x_rotation += delta_x
		head.position.y = camera_x_rotation/200 + .25
	elif event is InputEventMouseMotion and zooming:
		camera.fov = max(75,75+camera_x_rotation/10) + zoom

func _physics_process(delta: float) -> void:
	if paused:
		return
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	# Handle jump.
	if Input.is_action_just_pressed("jump") and !locked and """is_on_floor()""":
		velocity.y = jump_velocity
		v_at_jump = Vector2(0,0)
	if $KB.time_left:
		move_and_slide()
		return
	if Input.is_action_pressed("fire") and $Fire.is_stopped():
		fire()
	elif Input.is_action_just_released("fire"):
		$"Burst Delay".start(.7)
	if locked:
		var p = head.to_local(locked_e.position)
		var r = atan2(-p.x,-p.z)
		if abs(r) >.05:
			head.rotation.y += r/2 +.05
		else:
			head.rotation.y += r
		camera.rotation.x = atan(p.y)
		if head.rotation.y > PI:
			head.rotation.y -= 2*PI
		elif head.rotation.y < -PI:
			head.rotation.y += 2*PI
		megaman.rotation.y = head.rotation.y
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
	
	
	if !is_on_floor() and !locked:
		var norm = Vector2(velocity.x,velocity.z)
		velocity.z += direction.z * movement_speed / 40
		velocity.x += direction.x * movement_speed / 40
		if norm.length() > movement_speed:
			norm = norm.normalized() * movement_speed
			velocity.z = norm.y
			velocity.x = norm.x
		
	elif !locked:
		velocity.z = direction.z * movement_speed
		velocity.x = direction.x * movement_speed
	else:
		velocity.z = 0
		velocity.x = 0
	pos = position
	move_and_slide()

func fire():
	if burst:
		$"Burst Delay".stop()
	megaman.rotation.y = head.rotation.y
	if burst:
		burst -= 1
		if !burst:
			$"Burst Delay".start(.7)
	else:
		return
	add_child(load("res://scenes/bullet.tscn").instantiate())
	var p = Vector3(0,.2,0)
	p += Vector3(-sin(head.rotation.y),0,-cos(head.rotation.y))/2.0
	var b = $Bullet
	$Bullet.reparent(get_parent().get_node("Projectiles"))
	b.position = p + position
	if locked:
		b.velocity = (locked_e.position - b.position).normalized()
	else:
		var poss = p
		poss.y = 0
		b.velocity = poss.normalized()
	$Fire.start((8.0-rapid)/30.0)
func rotate_megaman(offset = 0.0):
	if locked:
		megaman.rotation.y = head.rotation.y
		return
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

func knockback(from):
	velocity = Vector3(0,0,0)
	position.y += .05
	move_and_slide()
	var p = (position - from.position).normalized()*.1
	p.y = 0
	position += p*.1
	velocity = (position - from.position).normalized() * 3
	velocity.y = 1
	move_and_slide()
	$KB.start()

func prioritize():
			locked = true
			#lockon priority
			var priority_list = []
			for i in get_parent().get_node("Enemies").get_children():
				var p = head.to_local(i.position)
				var priority = sqrt(-p.z-p.x*p.x)/((-p.z+2)*sqrt(-p.z-p.x*p.x)*(abs(p.x)+1)) - abs(p.y)
				if is_nan(priority):
					continue
				priority_list.append([priority,i])
			priority_list.sort()
			if len(priority_list) >= 1:
				locked_e = priority_list[-1][1]
				marker.visible = true
				marker.reparent(locked_e)
				marker.position = Vector3(0,0,0)
			
			megaman.rotation.y = head.rotation.y

func _on_zoom_timeout() -> void:
	zooming = true


func _on_burst_delay_timeout() -> void:
	if burst >= 0:
		burst = energy+3
