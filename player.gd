extends CharacterBody2D


const SPEED = 300.0
@export var JUMP_VELOCITY = -700
var jump_charge_time = 0
var channeling = false
var last_direction = 0
var is_jumping
var is_stunned = false
var was_high_fall = false
var is_falling = false

var high_jump = false
var mask = false


func _physics_process(delta: float) -> void:
	if velocity.y >0:
		is_falling = true
	if velocity.y>1000:
		was_high_fall=true
	# Add the gravity.
	if not is_on_floor():
		if is_jumping:
			if velocity.x == 0:
				last_direction *= -0.5
			velocity.x = last_direction*SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED*0.02)
		velocity += get_gravity() * delta
		
	if is_on_floor():
		# Handle jump.
		is_jumping = false
		if was_high_fall:
			print("highfall")
			start_stun()
		last_direction = 0
		
	if Input.is_action_pressed("ui_accept") and can_channel_jump():
		channeling = true
		jump_charge_time += delta
			
	if channeling and (jump_charge_time > 1 or Input.is_action_just_released("ui_accept")) and !is_stunned:
		start_jump()
		channeling = false
			
	var direction = 0
	if Input.is_action_pressed("move_right"):
		direction = 1
	elif Input.is_action_pressed("move_left"):
		direction = -1
	if direction and is_on_floor() and not channeling and !is_stunned:
		velocity.x = direction * SPEED
	elif is_on_floor():
		velocity.x = move_toward(velocity.x, 0, SPEED*0.5)

	move_and_slide()

func can_channel_jump():
	return !is_stunned and is_on_floor() and mask
	
func start_jump():
	last_direction = 0
	if Input.is_action_just_pressed("move_right") or Input.is_action_pressed("move_right"):
		last_direction = 1
	if Input.is_action_just_released("move_left") or Input.is_action_pressed("move_left"):
		last_direction = -1
		
	is_jumping = true	
	velocity.y = JUMP_VELOCITY * jump_charge_time
	velocity.x = last_direction * SPEED
	
	jump_charge_time = 0
	

func start_stun():
	was_high_fall = false
	is_stunned = true
	await get_tree().create_timer(1 ).timeout
	is_stunned = false
