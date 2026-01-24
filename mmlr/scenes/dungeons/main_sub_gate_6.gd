extends Node3D

@onready var player = $Megaman
@onready var main = get_parent()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_warp_zone_body_entered(_body: Node3D) -> void:
	var seven = load("res://scenes/dungeons/main_sub_gate_7.tscn").instantiate()
	main.add_child(seven)
	seven.get_node("Megaman").position = Vector3(-.5,-2,3)
	seven.get_node("Megaman").get_node("Head").rotate_y(PI)
	seven.get_node("Megaman").get_node("Megaman").rotate_y(PI)
	queue_free()



func _on_w_4_body_entered(body: Node3D) -> void:
	var seven = load("res://scenes/dungeons/main_sub_gate_4.tscn").instantiate()
	main.add_child(seven)
	seven.get_node("Megaman").position = Vector3(-6,-2,-26.5)
	seven.get_node("Megaman").get_node("Head").rotate_y(-PI/2)
	seven.get_node("Megaman").get_node("Megaman").rotate_y(-PI/2)
	queue_free()
