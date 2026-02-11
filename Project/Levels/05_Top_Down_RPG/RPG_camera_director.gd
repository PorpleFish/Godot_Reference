extends Node2D

@export var main_camera : PhantomCamera2D
@export var room: RPG_Room

func _rpg_room_initialized() -> void:
	main_camera.follow_target = room.player
