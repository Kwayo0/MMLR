extends Control

@onready var megaman = get_node("/root/Main").get_children()[0].get_node("Megaman")
var last = false
var which = 0
var textarray
var length = 0
var typewrite

func _process(_delta: float) -> void:
	if $Panel/VBoxContainer/MarginContainer2/speech.text == "":
		queue_free()
	if textarray == null:
		return
	if Input.is_action_just_pressed("ui_accept"):
		if $Panel/VBoxContainer/MarginContainer2/speech.visible_ratio != 1:
			$Panel/VBoxContainer/MarginContainer2/speech.visible_ratio = 1
			return
		if last:
			megaman.paused = false
			print("queuein free")
			queue_free()
		else:
			which += 1
			print(length)
			get_node("Panel/VBoxContainer/MarginContainer2/speech").text = textarray[which]
			if which == length - 1:
				last = true
		typewrite = get_tree().create_tween()
		$Panel/VBoxContainer/MarginContainer2/speech.visible_ratio = 0
		typewrite.tween_property($Panel/VBoxContainer/MarginContainer2/speech,"visible_ratio",1,len($Panel/VBoxContainer/MarginContainer2/speech.text)/50.0)
	

func talk(who, what):
	print(get_node("/root/Main").get_children()[0])
	megaman.paused = true
	get_parent().get_parent().add_child(load("res://scenes/UI/dialogue.tscn").instantiate())
	get_node("Panel/VBoxContainer/MarginContainer/name").text = who
	
	if typeof(what) == TYPE_STRING:
		last = true
		get_node("Panel/VBoxContainer/MarginContainer2/speech").text = what
		typewrite = get_tree().create_tween()
		$Panel/VBoxContainer/MarginContainer2/speech.visible_ratio = 0
		typewrite.tween_property($Panel/VBoxContainer/MarginContainer2/speech,"visible_ratio",1,len($Panel/VBoxContainer/MarginContainer2/speech.text)/50.0)
	elif typeof(what) == TYPE_ARRAY:
		last = false
		textarray = what
		length = len(textarray)
		get_node("Panel/VBoxContainer/MarginContainer2/speech").text = what[0]
		typewrite = get_tree().create_tween()
		$Panel/VBoxContainer/MarginContainer2/speech.visible_ratio = 0
		typewrite.tween_property($Panel/VBoxContainer/MarginContainer2/speech,"visible_ratio",1,len($Panel/VBoxContainer/MarginContainer2/speech.text)/50.0)
		
