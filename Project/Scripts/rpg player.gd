extends CharacterBody2D

@export var walk_bob_frequency : float = 1.9
@export var walk_bob_amplitude : float = 0.08
@export var walk_bob_return_speed : float = 0.08

@export var walk_spin_frequency : float = 1.9
@export var walk_spin_amplitude : float = 0.08
@export var walk_spin_return_speed : float = 0.08

const move_speed = 300.0
const acceleration = 0.1
const decceleration = 0.1

var walk_time : float = 0.0

@onready var sprite: AnimatedSprite2D = %Sprite

func _physics_process(delta: float) -> void:
	var direction : Vector2
	
	direction.x = Input.get_axis("left", "right")
	direction.y = Input.get_axis("forth", "back")
	
	if direction:
		walk_time += delta
		sprite.position = _walk_bob(walk_time)
		sprite.rotation = _walk_rotate(walk_time)
		velocity = lerp(velocity, direction * move_speed, acceleration)
		if abs(velocity.x) > 0.5:
			if direction.x > 0.0:
				sprite.play("Walk_Right")
			else:
				sprite.play("Walk_Left")
	else:
		sprite.position = lerp(sprite.position, Vector2.ZERO, walk_bob_return_speed)
		sprite.rotation = lerp(sprite.rotation, 0.0, walk_spin_return_speed)
		velocity = lerp(velocity, Vector2.ZERO, decceleration)
		if abs(velocity.x) > 0.5:
			if velocity.x > 0.0:
				sprite.play("Idle_Right")
			else:
				sprite.play("Idle_Left")

	move_and_slide()


func _walk_bob(time : float) -> Vector2: 
	var pos = Vector2.ZERO
	pos.y = sin(time * walk_bob_frequency) * walk_bob_amplitude
	pos.x = cos(time * walk_bob_frequency) * walk_bob_amplitude
	return pos


func _walk_rotate(time : float) -> float: 
	var rot : float = 0.0
	rot = sin(time * walk_spin_frequency) * walk_spin_amplitude
	return rot
