extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var horokko
var lasty = 0
var player
var buffer = 1

func _ready() -> void:
	visible = false

func _physics_process(delta: float) -> void:
	if scale.x > 2:
		if buffer == 0:
			queue_free()
		else:
			buffer -= 1
	# Add the gravity.
	if velocity.y != 0:
		lasty = velocity.y
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		velocity *= .7
		if abs(lasty) > .05:
			velocity.y = abs(lasty)*.7
			
	move_and_slide()


func _on_starter_timeout() -> void:
	visible = true
	position = Vector3(0,.125,-.15)
	reparent(get_parent().get_parent().get_parent().get_parent().get_node("Objects"))
	velocity = (position - horokko.position).normalized() * 3
	$Explode.start()


func _on_damage_body_entered(body: Node3D) -> void:
	if body == player:
		player.knockback(self)
		queue_free()


func _on_explode_timeout() -> void:
	scale = Vector3(3.0,3.0,3.0) #scale the area only, scale all is only for visual
	buffer = 1
	#animation
