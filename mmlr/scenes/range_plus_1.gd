extends MeshInstance3D

func _on_static_body_3d_area_entered(area: Area3D) -> void:
	for i in get_parent().get_node("Projectiles").get_children():
		if area == i:
			var e = get_parent().get_node("Megaman")
			e.bRange += 1
			if e.bRange > 7:
				e.bRange = 7
