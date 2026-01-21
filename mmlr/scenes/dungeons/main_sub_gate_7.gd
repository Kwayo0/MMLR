extends Node3D

@onready var player = $Megaman
@onready var main = get_parent()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_warp_zone_body_entered(_body: Node3D) -> void:
	var six = load("res://scenes/main_sub_gate_6.tscn").instantiate()
	main.add_child(six)
	six.get_node("Megaman").position = Vector3(-21.5,0,10)
	queue_free()
