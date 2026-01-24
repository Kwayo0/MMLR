extends Node3D

@onready var player = $Megaman
@onready var main = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_warp_zone_body_entered(_body: Node3D) -> void:
	var three = preload("res://scenes/dungeons/main_sub_gate_3.tscn").instantiate()
	main.add_child(three)
	three.get_node("Megaman").position = Vector3(-6,-1.5,-16.5)
	three.get_node("Megaman").get_node("Head").rotate_y(-PI/2)
	three.get_node("Megaman").get_node("Megaman").rotate_y(-PI/2)
	queue_free()

func _on_warp_zone_2_body_entered(_body: Node3D) -> void:
	var four = preload("res://scenes/dungeons/main_sub_gate_4.tscn").instantiate()
	main.add_child(four)
	four.get_node("Megaman").position = Vector3(-3,0,-.5)
	four.get_node("Megaman").get_node("Head").rotate_y(PI/2)
	four.get_node("Megaman").get_node("Megaman").rotate_y(PI/2)
	queue_free()


func _on_warp_zone_3_body_entered(_body: Node3D) -> void:
	var one = load("res://scenes/dungeons/main_sub_gate_1.tscn").instantiate()
	main.add_child(one)
	one.get_node("Megaman").position = Vector3(-.5,0,-3.5)
	one.get_node("Megaman").get_node("Head").rotate_y(PI)
	one.get_node("Megaman").get_node("Megaman").rotate_y(PI)
	queue_free()
