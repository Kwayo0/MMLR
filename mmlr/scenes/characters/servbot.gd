extends CharacterBody3D


const SPEED = 5.0
@onready var ani = $body/AnimationPlayer

func _ready() -> void:
	ani.play("Idle")

func _physics_process(delta: float) -> void:
	pass
	move_and_slide()
