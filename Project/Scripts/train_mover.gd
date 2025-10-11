extends PathFollow3D

@export var remote_transform : RemoteTransform3D
@export var meters_per_second : float

func _process(delta: float) -> void:
	progress = progress + delta * meters_per_second
