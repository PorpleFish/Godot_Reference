extends Button

@export var level_path : String

func _ready() -> void:
	ResourceLoader.load_threaded_request(level_path)

func _pressed() -> void:
	get_tree().change_scene_to_file(level_path)
