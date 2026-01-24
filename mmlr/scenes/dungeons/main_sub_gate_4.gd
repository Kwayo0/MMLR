extends Node3D

@onready var player = $Megaman
@onready var main = get_parent()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_warp_zone_body_entered(_body: Node3D) -> void:
	var six = load("res://scenes/dungeons/main_sub_gate_6.tscn").instantiate()
	main.add_child(six)
	six.get_node("Megaman").position = Vector3(-.5,-1,-1.5)
	six.get_node("Megaman").get_node("Head").rotate_y(PI/2)
	six.get_node("Megaman").get_node("Megaman").rotate_y(PI/2)
	queue_free()




func _on_w2_body_entered(_body: Node3D) -> void:
	var six = load("res://scenes/dungeons/main_sub_gate_2.tscn").instantiate()
	main.add_child(six)
	six.get_node("Megaman").position = Vector3(1,0,-23.5)
	six.get_node("Megaman").get_node("Head").rotate_y(-PI/2)
	six.get_node("Megaman").get_node("Megaman").rotate_y(-PI/2)
	queue_free()


func _on_w_3_body_entered(_body: Node3D) -> void:
	var six = load("res://scenes/dungeons/main_sub_gate_3.tscn").instantiate()
	main.add_child(six)
	six.get_node("Megaman").position = Vector3(1.5,-1,-29)
	six.get_node("Megaman").get_node("Head").rotate_y(PI)
	six.get_node("Megaman").get_node("Megaman").rotate_y(PI)
	queue_free()
