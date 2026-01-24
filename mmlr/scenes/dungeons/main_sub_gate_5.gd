extends Node3D

@onready var player = $Megaman
@onready var main = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_warp_zone_body_entered(body: Node3D) -> void:
	var six = load("res://scenes/dungeons/main_sub_gate_3.tscn").instantiate()
	main.add_child(six)
	six.get_node("Megaman").position = Vector3(.5,-1,-2)
	queue_free()
