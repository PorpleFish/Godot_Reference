extends CharacterBody3D
class_name Third_Person
@export_subgroup("01 - Movement")
@export var acceleration : float = 10
@export var max_speed : float = 3
@export var breaking_speed : float = 1
@export var weight : float = 5

@export_subgroup("02 - Camera")
@export var camera : Camera3D
@export var third_person_phantom_camera : PhantomCamera3D

@export_subgroup("03 - Gameplay")
@export var spawn_point : Node3D
@export var respawn_height :  = -10

var is_possessed : bool = true
var is_paused : bool = false
var gravity : float
var target_rotation : float
var pause_menu : Control
var camera_target_rotation : Vector3

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		pause_handler()

func _physics_process(delta: float) -> void:
	handle_gravity(delta)
	handle_input(delta)
	handle_camera_input(delta)
	handle_level_bounds()
	
	move_and_slide()
	# If the character is moving, rotate in the flattened movement direction.
	if Vector2(velocity.z, velocity.x).length() > 0:
		target_rotation = Vector2(velocity.z, velocity.x).angle()
	rotation.y = lerp_angle(rotation.y, target_rotation, delta * 10)

func handle_input(delta : float) -> void:
	if !is_possessed:
		return
	var input = get_normal_move_input()
	var velocity_2D = Vector2(velocity.x, velocity.z)
	
	# TODO: TRY limit_length()
	# TODO: Get input working so you can move slowly by gently nudging the stick?
	if input.length() < 0.5:
		velocity_2D = velocity_2D.lerp(Vector2.ZERO, breaking_speed)
		velocity = Vector3(velocity_2D.x, velocity.y, velocity_2D.y)
		return

	velocity_2D += input.rotated(-camera.rotation.y) * delta * acceleration

	if velocity_2D.length() > max_speed:
		velocity_2D = velocity_2D.normalized()
		velocity_2D = velocity_2D * max_speed
		
	velocity = Vector3(velocity_2D.x, velocity.y - gravity, velocity_2D.y)

func handle_camera_input(delta: float) -> void:
	var input := Vector2.ZERO
	input = Input.get_vector("camera_left", "camera_right", "camera_up", "camera_down")
	input *= delta
	input.y *= -1
	input = input.limit_length(1.0)
	camera_target_rotation += Vector3(input.y, input.x, 0)
	camera_target_rotation.x = clamp(camera_target_rotation.x, -1.2, 0.15)
	print(camera_target_rotation.x)
	
	var delta_rotation : Vector3
	delta_rotation.x = lerp_angle(
		third_person_phantom_camera.get_third_person_rotation().x, 
		camera_target_rotation.x, 
		delta * 10
	)
	delta_rotation.y = lerp_angle(
		third_person_phantom_camera.get_third_person_rotation().y, 
		camera_target_rotation.y, 
		delta * 10
	)
	third_person_phantom_camera.set_third_person_rotation(delta_rotation)

func handle_gravity(delta) -> void:
	gravity += weight * delta
	if is_on_floor():
		gravity = 0
	velocity.y = velocity.y - gravity
	
func handle_level_bounds() -> void:
	if position.y < respawn_height:
		position = spawn_point.position

func get_normal_move_input() -> Vector2:
	var input := Vector2.ZERO
	input = Input.get_vector("left", "right", "forth", "back")
	if input.length() > 0.0:
		return input
	return Vector2.ZERO

func pause_handler() -> void:
	if is_paused:
		unpause_handler()
	else:
		is_paused = true
		is_possessed = false
		var pause_scene = load(Paths.PAUSE)
		pause_menu = pause_scene.instantiate()
		pause_menu.connect("resume_game", unpause_handler)
		add_child(pause_menu)

func unpause_handler() -> void:
	is_paused = false
	is_possessed = true
	remove_child(pause_menu)
