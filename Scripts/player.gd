extends CharacterBody2D

# Player movement properties
const SPEED = 300.0
const JUMP_VELOCITY = -600.0
var gravity = 980
var score = 0

@onready var animated_sprite = $AnimatedSprite2D

func _ready():
	pass

func _physics_process(delta):
	# Apply gravity
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get horizontal movement direction (-1, 0, or 1)
	var direction = Input.get_axis("ui_left", "ui_right")
	
	# Set horizontal velocity based on direction
	if direction:
		velocity.x = direction * SPEED
		animated_sprite.flip_h = direction < 0  # Flip sprite based on direction
	else:
		velocity.x = 0  # Stop when no direction pressed

	# Apply movement
	move_and_slide()
	
	# Update animations
	if not is_on_floor():
		animated_sprite.play("jump")
	else:
		if abs(velocity.x) > 10:
			animated_sprite.play("run")
		else:
			animated_sprite.play("idle")
	
	# Check if player fell off the level
	if position.y > 1000:  # Adjust based on level size
		position = Vector2(0, 0)


## Called when player collects a coin
#func collect_coin():
	#score += 1
	## Emit signal for UI to update
	#emit_signal("score_changed", score)
	## Play sound if you have one
	#if has_node("CoinSound"):
		#$CoinSound.play()
#
## Handle enemy collision
#func _on_enemy_detector_body_entered(body):
	#if body.is_in_group("enemies"):
		#if velocity.y > 0:  # Falling onto enemy
			## Bounce off enemy
			#velocity.y = JUMP_VELOCITY * 0.5
			## Tell enemy it was hit
			#body.queue_free()
		#else:
			## Player hit by enemy - restart level
			#position = get_parent().get_node("StartPosition").position
#
## Victory condition
#func _on_goal_area_body_entered(body):
	#if body == self:  # If player enters goal
		#emit_signal("level_completed")
		#set_physics_process(false)  # Freeze player
#
## Signals
#signal score_changed(new_score)
#signal level_completed
