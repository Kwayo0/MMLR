extends CharacterBody3D


const SPEED = 5.0
@onready var ani = $body/AnimationPlayer
@onready var placeholder = preload("res://assets/models/Servbot/pface.tres")


func _ready() -> void:
	ani.play("Idle")
	set_face(placeholder)

func set_face(face):
	$body/Main/BodyTop2/Head2/Face.set_surface_override_material(0,face)
