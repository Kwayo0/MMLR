extends ItemList


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_item_activated(index: int) -> void:
	match index:
		0:
			get_parent().get_parent().get_parent().get_parent().add_child(load("res://scenes/dungeons/main_sub_gate_1.tscn").instantiate())
			get_parent().get_parent().get_parent().queue_free()
		1:
			get_parent().get_parent().get_parent().get_parent().add_child(load("res://scenes/overworld/apple_market.tscn").instantiate())
			get_parent().get_parent().get_parent().queue_free()
