extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_child(load("res://scenes/main_sub_gate_1.tscn").instantiate())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
