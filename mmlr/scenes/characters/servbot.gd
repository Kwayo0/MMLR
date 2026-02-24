extends CharacterBody3D


const SPEED = 5.0
@onready var ani = $body/AnimationPlayer
@onready var placeholder = preload("res://assets/models/Servbot/pface.tres")
@export var megaman: CharacterBody3D


func _ready() -> void:
	ani.play("Idle")
	set_face(placeholder)
	$Area3D.connect("area_entered", talk)

func set_face(face):
	$body/Main/BodyTop2/Head2/Face.set_surface_override_material(0,face)

func talk(area):
	get_node("/root/Main").add_child(load("res://scenes/UI/dialogue.tscn").instantiate())
	var dia = get_node("/root/Main").get_children()[-1]
	print(dia)
	print(dia.visible)
	if area == megaman.get_node("Megaman/interaction"):
		dia.talk("Servbot",["Hello, Megaman!","This dialogue box has a second page!", "Isn't that amazing?ww"])
