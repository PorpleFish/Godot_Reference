extends Node3D

@export var up_speed : float
@export var down_speed : float
@export var vertical_offset : float
@export var up_transition : Tween.TransitionType
@export var down_transition : Tween.TransitionType
@export var up_ease_type : Tween.EaseType
@export var down_ease_type : Tween.EaseType

@onready var start_pos : Vector3 = position

func _ready() -> void:
	move_up()

func _process(delta: float) -> void:
	rotation.y += delta

func move_up() -> void:
	var move_tween = create_tween()
	move_tween.set_trans(up_transition)
	
	move_tween.connect("finished", move_down)
	move_tween.tween_property(
		self, 
		'position', 
		start_pos + Vector3(0, vertical_offset/2, 0), 
		down_speed
	)

func move_down() -> void:
	var move_tween = create_tween()
	move_tween.set_trans(down_transition)
	
	move_tween.connect("finished", move_up)
	move_tween.tween_property(
		self, 
		'position', 
		start_pos - Vector3(0, vertical_offset/2, 0), 
		down_speed
	)
