extends Node2D

var player_in_range = false
var player
var active_dialog = false
var has_mask = true
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
		$Label.visible = false
		if player.is_on_floor():
			if has_mask:
				take_mask()
			else:
				SignalBus.emit_signal("display_dialog", "no_mask")
				active_dialog = true
	elif active_dialog and event.is_action_pressed("interact"):
		#SignalBus.emit_signal("hide_dialog")
		active_dialog = false

func take_mask():
	$MaskImage.visible = false
	active_dialog = true
	has_mask = false
	if mask:
		player.totem_interaction(mask)
	if dialog_key:
		SignalBus.emit_signal("display_dialog", dialog_key)

func _on_interaction_enter(body: Node2D) -> void:
	if body.name == "Player":
		if has_mask:
			$Label.text = "Q"
		player = body
		player_in_range = true

func _on_interaction_exit(body: Node2D) -> void:
	if body.name == "Player":
		$Label.text = "?"
		player_in_range = false
	if !has_mask:
		$Label.visible = false

func _on_proximity_exit(body):
	$Label.visible = false
	if active_dialog:
		active_dialog = false
		SignalBus.emit_signal("hide_dialog")


func _on_proximity_entered(body: Node2D) -> void:
	if has_mask and body.name == "Player":
		$Label.text = "?"
		$Label.visible = true
