extends Node

var playback : AudioStreamPlaybackPolyphonic

const p_open : String = "res://Audio/UI/SFX_Open.ogg"
const p_close : String = "res://Audio/UI/SFX_Close.ogg"
const p_highlight : String = "res://Audio/UI/SFX_Highlight.ogg"
const p_press : String = "res://Audio/UI/SFX_Select.ogg"

enum sound_type {
	OPEN,
	CLOSE,
	HIGHLIGHT,
	SWITCH,
	PRESS
}

func play_sound(key : sound_type):
	match key:
		sound_type.OPEN: playback.play_stream(preload(p_open), 0, 0, randf_range(0.9, 1.1))
		sound_type.CLOSE: playback.play_stream(preload(p_close), 0, 0, randf_range(0.9, 1.1))
		sound_type.HIGHLIGHT: playback.play_stream(preload(p_highlight), 0, 0, randf_range(0.9, 1.1))
		sound_type.PRESS: playback.play_stream(preload(p_press), 0, -3, randf_range(0.9, 1.1))

func _ready():
	connect_buttons(get_tree().root)
	get_tree().connect("node_added", _on_SceneTree_node_added)

func _on_SceneTree_node_added(node): 
	if node is Button:
		connect_to_button(node)

func connect_buttons(root):
	for child in root.get_children():
		if child is BaseButton:
			connect_to_button(child)
		connect_buttons(child)

func connect_to_button(button : BaseButton):
	var player = AudioStreamPlayer.new()
	add_child(player)
	var stream = AudioStreamPolyphonic.new()
	stream.polyphony = 32
	player.stream = stream
	player.bus = "User Interface"
	player.play()
	playback = player.get_stream_playback()
	button.connect("pressed", handle_button_press)
	button.connect("focus_entered", handle_button_focus)

func handle_button_press():
	play_sound(sound_type.PRESS)
	
func handle_button_focus():
	play_sound(sound_type.HIGHLIGHT)
