extends Control

signal resume_game

@export var Initial_Focus : Button

func _ready() -> void:
	Initial_Focus.grab_focus.call_deferred()

func _resume_pressed() -> void:
	resume_game.emit()
	queue_free()

func _options_pressed() -> void:
	print ("[TODO] Make options menu!")

func _quit_pressed() -> void:
	get_tree().change_scene_to_file(Paths.MAIN_MENU)
