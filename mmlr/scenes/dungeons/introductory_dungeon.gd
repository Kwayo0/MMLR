extends Node3D

@onready var player = $Megaman
@onready var main = get_parent()
@onready var d = preload("res://scenes/dungeons/intro_boss.tscn").instantiate()

func _on_area_3d_body_entered(body: Node3D) -> void:
	main.add_child(d)
	d.get_node("Megaman").position = Vector3(-0.5,0,.5)
	queue_free()
