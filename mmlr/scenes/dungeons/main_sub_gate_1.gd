extends Node3D

@onready var player = $Megaman
@onready var main = get_parent()
@onready var two = preload("res://scenes/dungeons/main_sub_gate_2.tscn").instantiate()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_warp_zone_body_entered(_body: Node3D) -> void:
	main.add_child(two)
	two.get_node("Megaman").position = Vector3(0.5,0,-.5)
	queue_free()
