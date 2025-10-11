extends StaticBody3D

var last_update_pos : Vector3 = position

func _physics_process(_delta: float) -> void:
	constant_angular_velocity = position - last_update_pos
	last_update_pos = position
