extends Node2D
class_name RPG_Room

@export var entrances : Array[RPG_Entrance]

signal initialized

var player : Node2D

func get_entrance(entrance_name : String) -> RPG_Entrance:
	return entrances[entrances.find(entrance_name)]


func initialize_level(_player: Node2D) ->void:
	player = _player
	initialized.emit()
