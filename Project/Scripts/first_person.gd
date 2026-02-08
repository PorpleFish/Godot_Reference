extends CharacterBody3D

@export var walk_speed : float = 400
@export var sprint_speed : float = 650
@export var jump_velocity : float  = 4.5
@export var sensitivity = 0.0025

@export var bob_frequency : float = 1.9
@export var bob_amplitude : float = 0.08

@onready var head: Node3D = $Head
@onready var first_person_camera: Camera3D = $Head/First_Person_Camera

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var bob_time

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	bob_time = 0


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * sensitivity)
		first_person_camera.rotate_x(-event.relative.y * sensitivity)
		first_person_camera.rotation.x = clamp(first_person_camera.rotation.x, deg_to_rad(-40), deg_to_rad(60))


func _physics_process(delta: float) -> void:
	# Add gravity
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	# jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	# horizontal movement
	var speed_scalar : float = sprint_speed if Input.is_action_pressed("sprint") else walk_speed
	var input_direction = Input.get_vector("left", "right", "forth", "back")
	var direction = (head.transform.basis * Vector3(input_direction.x, 0, input_direction.y)).normalized()
	if is_on_floor():
		if direction:
			velocity.x = direction.x * (speed_scalar) * delta
			velocity.z = direction.z * (speed_scalar) * delta
		else:
			velocity.x = 0.0
			velocity.z = 0.0

	# head bob
	bob_time += delta * velocity.length() * float(is_on_floor())
	first_person_camera.transform.origin = _head_bob(bob_time)
	
	move_and_slide()


func _head_bob(time : float) -> Vector3: 
	var pos = Vector3.ZERO
	pos.y = sin(time * bob_frequency) * bob_amplitude
	pos.x = cos(time * bob_frequency / 2) * bob_amplitude
	return pos
