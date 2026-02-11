@tool
class_name RPG_Entrance
extends Area2D

@export_category("Entrance")
@export var entrance_name : String
@export_file("*tscn") var target_level : String
@export var target_entrance : String
@export var spawn_offset : Vector2:
	set(new_offset):
		spawn_offset = new_offset
		%"Spawn Point Indicator".position = spawn_offset

@export_category("Zone")
@export var zone_size : Vector2 = Vector2(32, 32):
	set(new_setting):
		zone_size = new_setting
		_size_changed()

func _ready() -> void:
	if not Engine.is_editor_hint():
		%"Spawn Point Indicator".visible = false


func _size_changed():
	%Shape.shape = %Shape.shape.duplicate()
	%Shape.shape.set_size(zone_size)


func _entrance_entered(area: Area2D) -> void:
	if area.name == "Player Area":
		var level_parent : RPG_Level_Manager = get_parent().get_parent()
		if level_parent:
			level_parent.load_level(target_level, target_entrance)
