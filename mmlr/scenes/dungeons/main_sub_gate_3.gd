extends Node3D

@onready var player = $Megaman
@onready var main = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_warp_zone_body_entered(_body: Node3D) -> void:
	var five = load("res://scenes/dungeons/main_sub_gate_5.tscn").instantiate()
	main.add_child(five)
	five.get_node("Megaman").position = Vector3(.5,0,3)
	five.get_node("Megaman").get_node("Head").rotate_y(PI)
	five.get_node("Megaman").get_node("Megaman").rotate_y(PI)
	queue_free()


func _on_warp_zone_2_body_entered(_body: Node3D) -> void:
	var four = load("res://scenes/dungeons/main_sub_gate_4.tscn").instantiate()
	main.add_child(four)
	four.get_node("Megaman").position = Vector3(14.5,1.5,-4.5)
	queue_free()


func _on_warp_zone_3_body_entered(_body: Node3D) -> void:
	var two = load("res://scenes/dungeons/main_sub_gate_2.tscn").instantiate()
	main.add_child(two)
	two.get_node("Megaman").position = Vector3(2,.75,-12.5)
	two.get_node("Megaman").get_node("Head").rotate_y(PI/2)
	two.get_node("Megaman").get_node("Megaman").rotate_y(PI/2)
	queue_free()
