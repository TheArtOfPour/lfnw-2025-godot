extends CharacterBody2D

var direction = 1
var speed = 50
var patrol_distance = 100
var start_position

func _ready():
	start_position = global_position.x
	add_to_group("enemies")

func _physics_process(delta):
	# Patrol logic
	if global_position.x > start_position + patrol_distance:
		direction = -1
		$AnimatedSprite2D.flip_h = true
	elif global_position.x < start_position - patrol_distance:
		direction = 1
		$AnimatedSprite2D.flip_h = false
	
	velocity.x = direction * speed
	
	# Apply gravity
	if not is_on_floor():
		velocity.y += 980 * delta
	
	move_and_slide()
