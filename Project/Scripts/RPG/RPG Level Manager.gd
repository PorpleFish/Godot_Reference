extends Node2D
class_name RPG_Level_Manager

var current_target_entrance : String
@onready var rpg_protagonist: CharacterBody2D = $"../RPG_Protagonist"
@export_file_path("*.tscn") var first_level : String

var level : RPG_Room

func _ready() -> void:
	load_level(first_level)


func load_level(open_path : String, target_entrance : String = ""):
	var level_resource = load(open_path)
	if level:
		level.queue_free()
	
	level = level_resource.instantiate()
	level.initialize_level(rpg_protagonist)
	add_child(level)
	if target_entrance.length() > 0:
		var entrance : Node2D = level.get_entrance(target_entrance)
		if entrance:
			rpg_protagonist.position = entrance.position + entrance.spawn_offset
	
