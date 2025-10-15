extends Area2D

var player_in_range = false
var player
@export var mask: Mask


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player_in_range and Input.is_action_just_pressed("interact"):
		if player.is_on_floor():
			if mask:
				player.totem_interaction(mask)


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		player = body
		player_in_range = true


func _on_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		player_in_range = false
