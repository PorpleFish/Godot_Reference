extends Node3D

@export_subgroup("Properties")
@export var target : Node3D

@onready var camera_rotation : Vector3 = rotation_degrees

func _physics_process(delta: float) -> void:
	position = position.lerp(target.position, delta * 4)
	rotation_degrees = rotation_degrees.lerp(camera_rotation, delta)
