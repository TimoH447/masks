extends Node2D

var player_in_range = false
var player
var active_dialog = false
@export var mask: Mask
@export var dialog_key = ""

@onready var interaction_area = $InteractionArea
@onready var proximity_area = $ProximityArea

func _ready():
	interaction_area.body_entered.connect(_on_interaction_enter)
	interaction_area.body_exited.connect(_on_interaction_exit)
	proximity_area.body_exited.connect(_on_proximity_exit)

func _input(event: InputEvent) -> void:
	if player_in_range and event.is_action_pressed("interact") and !active_dialog:
		if player.is_on_floor():
			if mask:
				active_dialog = true
				player.totem_interaction(mask)
				SignalBus.emit_signal("display_dialog", dialog_key)
	elif active_dialog and event.is_action_pressed("interact"):
		SignalBus.emit_signal("hide_dialog")
		active_dialog = false


func _on_interaction_enter(body: Node2D) -> void:
	if body.name == "Player":
		player = body
		player_in_range = true

func _on_interaction_exit(body: Node2D) -> void:
	if body.name == "Player":
		player_in_range = false

func _on_proximity_exit(body):
	print("player ot our range")
	if active_dialog:
		active_dialog = false
		SignalBus.emit_signal("hide_dialog")
