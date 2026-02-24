extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@onready var player = get_parent().get_parent().get_node("Megaman")
@onready var gridmap = get_parent().get_parent().get_node("GridMap")
@onready var ray = $RayCast3D
@onready var wall_ray = $"Wall Ray"

var turn = 0
var state = 0
var sees = false
var ranj = false
var bomb = false
var stop = false
var attack = false

var angle

var health = 64
const POISE = 48
var poise = POISE

enum {
	IDLE,
	STALKING,
	CHASING,
	ATTACKING,
	BOMBING,
	REELING
}

func _physics_process(delta: float) -> void:
	ray.target_position = to_local(player.position + Vector3(0,.0625,0))
	ray.force_raycast_update()
	var vec_loc = to_local(player.position)
	angle = atan2(-vec_loc.x,-vec_loc.z)
	var dir = to_global(Vector3(0,0,-1))
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	if $KB.time_left:
		move_and_slide()
		return
	match state:
		IDLE:
			if !stop:
				velocity = (dir - position) / 5
			wall_ray.force_raycast_update()
			if wall_ray.get_collider() == gridmap:
				if turn == 0:
					turn = 2*PI/3
			if turn:
				rotate_y(.03)
				turn -= .03
				if turn <= 0:
					turn = 0
				
		STALKING:
			if !stop:
				velocity = (dir - position) / 5
				if angle > .02:
					rotate_y(.03)
				elif angle < -.02:
					rotate_y(-.03)
				else:
					rotate_y(angle)
		CHASING:
			if !stop:
				rotate_y(angle)
				velocity = ((player.position - position) - Vector3(0,(player.position - position).y,0) )* 2
		ATTACKING:
			if !stop:
				velocity = (player.position - position) * 2
				velocity.y = 0
				rotate_y(.3)
	
	

	move_and_slide()

func knockback(from):
	if poise > 0:
		return
	poise += POISE
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

func hurt(x):
	#animation
	if state == IDLE:
		if ray.get_collider() == player:
			state = STALKING
	health -= x
	poise -= x
	if health <= 0:
		if player.locked and player.locked_e == self:
			$Marker.visible = false
			$Marker.reparent(get_parent().get_parent().get_node("Other"))
			player.locked = false
		queue_free()

func stoptime(time):
	$Stop_time.wait_time = time
	$Stop_time.start()

func _on_range_body_entered(body: Node3D) -> void:
	if body == player:
		ranj = true
		match state:
			IDLE:
				if ray.get_collider() == player and sees:
					state = STALKING
					#play lock-on animation

func _on_range_body_exited(body: Node3D) -> void:
	if body == player:
		ranj = false
		if state == STALKING:
			state = CHASING
			stoptime(.5)
			$Chase_time.start()


func _on_sight_body_entered(body: Node3D) -> void:
	if body == player:
		sees = true
		if range:
				if ray.get_collider() == player and sees:
					state = STALKING
					#play lock-on animation
			
func _on_sight_body_exited(body: Node3D) -> void:
	if body == player:
		sees = false


func _on_bomb_body_entered(body: Node3D) -> void:
	if body == player:
		bomb = true
func _on_bomb_body_exited(body: Node3D) -> void:
	if body == player:
		bomb = false


func _on_bomb_time_timeout() -> void:
	if bomb and abs(angle) <= .05:
		stop = true
		velocity = Vector3(0,0,0)
		stoptime(2.0)
		$Bombs.add_child(load("res://scenes/characters/horokko_bomb.tscn").instantiate())
		$Bombs.get_children()[-1].horokko = self
		$Bombs.get_children()[-1].player = player

func _on_stop_time_timeout() -> void:
	stop = false
	if attack:
		$Attack_time.start()


func _on_attack_body_entered(body: Node3D) -> void:
	if body == player:
		attack = true
		if state != IDLE:
			velocity = Vector3(0,0,0)
			state = ATTACKING
			$Attack_time.start()

func _on_attack_body_exited(body: Node3D) -> void:
	if body == player:
		attack = false


func _on_attack_time_timeout() -> void:
	state = STALKING
	stoptime(1.0)
	rotate_y(angle)


func _on_chase_time_timeout() -> void:
	state = STALKING
	stoptime(.5)


func _on_damage_body_entered(body: Node3D) -> void:
	if body == player:
		player.knockback(self)
