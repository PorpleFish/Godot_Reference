extends CharacterBody2D

const move_speed = 300.0
const acceleration = 0.1
const decceleration = 0.1

@onready var sprite: AnimatedSprite2D = %Sprite

func _physics_process(_delta: float) -> void:
	var direction : Vector2
	
	direction.x = Input.get_axis("left", "right")
	direction.y = Input.get_axis("forth", "back")
	
	if direction:
		velocity = lerp(velocity, direction * move_speed, acceleration)
		if direction.x > 0.0:
			sprite.play("Walk_Right")
		else:
			sprite.play("Walk_Left")
	else:
		velocity = lerp(velocity, Vector2.ZERO, decceleration)
		if velocity.length() > 0.1:
			if velocity.x > 0.0:
				sprite.play("Idle_Right")
			else:
				sprite.play("Idle_Left")
	
	move_and_slide()
	
