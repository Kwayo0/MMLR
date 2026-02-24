extends MeshInstance3D




func _on_static_body_3d_area_entered(area: Area3D) -> void:
	for i in get_parent().get_node("Projectiles").get_children():
		if area == i:
			get_parent().get_node("Enemies").add_child(load("res://scenes/characters/horokko.tscn").instantiate())
			var e = get_parent().get_node("Enemies").get_children()[-1]
			e.position.x = (randf()*4 - 2) * .9
			e.position.z = (randf()*10 - 2) * .9
			e.position.y += .125
			e.rotation.y = 2*PI*randf()
			
