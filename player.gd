extends CharacterBody2D

const SPEED = 300.0
var SLIPPERINESS = 0.4
@export var JUMP_VELOCITY = -700
var jump_charge_time = 0
var channeling = false
var last_direction = 0
var is_jumping
var is_stunned = false
var was_high_fall = false
var is_falling = false

var is_jump_cooldown = false
var high_jump = false
var has_jump_ability = true
var is_wall_jumping = false
var has_wall_jump_ability = false
var wall_jump_direction
var is_wall_jump = false

var has_fire_mask = false
var current_mask

func _physics_process(delta: float) -> void:
	if velocity.y >0:
		is_falling = true
	if velocity.y>1000:
		was_high_fall=true
		
	if is_on_floor():
		# Handle jump.
		is_jumping = false
		if was_high_fall:
			print("highfall")
			start_stun()
		last_direction = 0
	# Jump behaviour and gravity
	elif can_wall_jump():
		is_wall_jumping = true
		is_jumping = false
		wall_jump_direction = -1 * last_direction
		velocity.y = 0
		velocity.x = 0
	else:		
		velocity += get_gravity() * delta
		if is_jumping:
			# Bouncing of walls
			if velocity.x == 0:
				last_direction *= -0.5
			velocity.x = last_direction*SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED*0.02)
			
	# Jump logic
	if Input.is_action_pressed("ui_accept") and can_channel_jump() and !is_stunned:
		channeling = true
		jump_charge_time += delta
	if channeling and (jump_charge_time > 1 or Input.is_action_just_released("ui_accept")) and !is_stunned and !is_jump_cooldown:
		start_jump()
		channeling = false
	
	# Movement on ground
	var direction = Input.get_axis("move_left","move_right")
	if direction and is_on_floor() and not channeling and !is_stunned:
		velocity.x = direction * SPEED
	elif is_on_floor():
		# determines how long the player moves after releasing the button
		velocity.x = move_toward(velocity.x, 0, SPEED* SLIPPERINESS)
	move_and_slide()

func can_channel_jump():
	if is_wall_jumping:
		return true
	return !is_stunned and is_on_floor() and has_jump_ability
	
func start_jump():
	start_jump_cd()
	last_direction = 0
	if Input.is_action_just_pressed("move_right") or Input.is_action_pressed("move_right"):
		last_direction = 1
	if Input.is_action_just_released("move_left") or Input.is_action_pressed("move_left"):
		last_direction = -1
		
	is_jumping = true
	velocity.y = JUMP_VELOCITY * jump_charge_time
	if is_wall_jumping:
		last_direction = wall_jump_direction
		print(wall_jump_direction)
		is_wall_jumping = false
	velocity.x = last_direction * SPEED
	
	jump_charge_time = 0

func start_jump_cd():
	is_jump_cooldown = true
	await get_tree().create_timer(0.5).timeout
	is_jump_cooldown = false
	
func start_stun():
	was_high_fall = false
	is_stunned = true
	await get_tree().create_timer(1).timeout
	is_stunned = false
	
func totem_interaction(mask):
	if current_mask:
		current_mask.remove(self)
	current_mask = mask
	mask.apply(self)
	
func is_touching_wall_jumpable() -> bool:
	if is_on_ceiling():
		return false
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if collider.is_in_group("wall_jump"):
			return true
	return false
	
func can_wall_jump() -> bool:
	if is_touching_wall_jumpable() and has_wall_jump_ability and (is_jumping or is_wall_jumping):
		return true
	return false
