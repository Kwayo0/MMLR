extends Area3D

var velocity
var power
var bRange

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bRange = [3,11.0/3.0,13.0/3.0,16.0/3.0,19.0/3.0,22.0/3.0,8.0,9.6][get_parent().bRange]
	var attack = get_parent().attack
	power = 24 + 8*attack  #up to level 6
	if attack == 7: 
		power = 90
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += velocity * delta * 5
	bRange -= delta * 5
	if bRange <= 0:
		#animation
		queue_free()


func _on_body_entered(body: Node3D) -> void:
	for i in get_parent().get_parent().get_node("Enemies").get_children():
		if body == i:
			i.hurt(power)
			i.knockback(self)
	queue_free()
