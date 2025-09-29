extends Control
enum main_menu_state {
	MAIN,
	LEVEL_SELECT,
	OPTIONS
}

@export var Initial_Focus : Button
@export var Level_Focus : Button
@export var Level_Follows : Array[PathFollow2D]

@export var Level_Buttons : Array[Button]
@export var Menu_Buttons : Array[Button]

@onready var ANIMATOR : AnimationPlayer = %"Menu Transitions"
@onready var state : main_menu_state = main_menu_state.MAIN

func _ready() -> void:
	ANIMATOR.connect("animation_finished", animation_finish_handler)
	Initial_Focus.grab_focus.call_deferred()
	for button in Level_Buttons:
		button.focus_mode = Control.FOCUS_NONE

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if (state == main_menu_state.LEVEL_SELECT):
			state = main_menu_state.MAIN
			ANIMATOR.play_backwards("Start")
			%Cursor_control.hide_cursor(0.7)
			%Cursor_control.should_lerp = false
			Initial_Focus.grab_focus.call_deferred()
			for button in Menu_Buttons:
				button.focus_mode = Control.FOCUS_ALL
			for button in Level_Buttons:
				button.focus_mode = Control.FOCUS_NONE
			var follow_tweens : Array[Tween]
			for index in range(Level_Follows.size()):
				var progress = 432
				follow_tweens.push_back(create_tween())
				follow_tweens[index].set_ease(Tween.EASE_OUT)
				follow_tweens[index].set_trans(Tween.TRANS_CUBIC)
				follow_tweens[index].tween_property(Level_Follows[index], "progress", progress, 0.6)
	if event.as_text() == "Left Mouse Button":
		print("Pos is: ", event.position)

func _start_pressed() -> void:
	ANIMATOR.play("Start")
	var follow_tweens : Array[Tween]
	for index in range(Level_Follows.size()):
		var progress = 430 - (Level_Follows.size() * 25) + index * 50
		follow_tweens.push_back(create_tween())
		follow_tweens[index].set_ease(Tween.EASE_OUT)
		follow_tweens[index].set_trans(Tween.TRANS_CUBIC)
		follow_tweens[index].tween_property(Level_Follows[index], "progress", progress, 0.9)
	%Cursor_control.hide_cursor(0.7)
	%Cursor_control.should_lerp = false
	for button in Menu_Buttons:
		button.focus_mode = Control.FOCUS_NONE
	for button in Level_Buttons:
		button.focus_mode = Control.FOCUS_ALL
	Level_Focus.grab_focus.call_deferred()
	state = main_menu_state.LEVEL_SELECT

func _options_pressed() -> void:
	print ("[TODO] Make options menu!")

func _quit_pressed() -> void:
	get_tree().quit()

func finished_menu_animation() -> void:
	match state:
		main_menu_state.MAIN:
			%Cursor_control.snap_to_control(Initial_Focus)
		main_menu_state.LEVEL_SELECT:
			%Cursor_control.snap_to_control(Level_Focus)
	%Cursor_control.show_cursor(0.1)
	%Cursor_control.should_lerp = true

func animation_finish_handler(animation : String) -> void:
	if animation == "Start":
		print("Finished start animation")
		finished_menu_animation()
