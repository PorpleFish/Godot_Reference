extends Control

const LEVEL_SELECT : String = "res://Levels/01_VFX_Zoo.tscn"

func _ready() -> void:
	ResourceLoader.load_threaded_request(LEVEL_SELECT)

func _start_pressed() -> void:
	var level_select = ResourceLoader.load(LEVEL_SELECT)
	get_tree().change_scene_to_packed(level_select)
	pass # Replace with function body.

func _options_pressed() -> void:
	print ("[TODO] Make options menu!")
	pass # Replace with function body.

func _quit_pressed() -> void:
	get_tree().quit()
