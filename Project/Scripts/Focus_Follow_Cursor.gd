extends Control

@onready var animation : AnimationPlayer = %Cursor_Animation

var should_lerp : bool = true

func _ready() -> void:
	animation.play("Idle")
	get_viewport().connect("gui_focus_changed", _focus_change_handler)

func _focus_change_handler(new_foc : Control):
	if should_lerp:
		var current_tween = create_tween()
		var target_pos : Vector2 = Vector2(new_foc.global_position.x - 50, new_foc.global_position.y - 7)
		current_tween.set_ease(Tween.EASE_OUT)
		current_tween.set_trans(Tween.TRANS_CUBIC)
		current_tween.tween_property(self, "global_position", target_pos, 0.7)

func hide_cursor(period : float) -> void:
	var hide_tween = create_tween()
	hide_tween.tween_property(self, "modulate", Color(0.0, 0.0, 0.0, 0.0), period / 4)

func show_cursor(period : float) -> void:
	var show_tween = create_tween()
	show_tween.tween_property(self, "modulate", Color(1.0, 1.0, 1.0, 1.0), period)

func snap_to_control(button : Control) -> void:
	position = Vector2(button.global_position.x - 50, button.global_position.y - 7)
