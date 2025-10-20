extends Node2D

var player_in_range = false
var player
var active_dialog = false
var completed_altar = false

@onready var interaction_area = $InteractionArea
@onready var proximity_area = $ProximityArea
@onready var fire_mask = $AltarImage/FireMaskImage
@onready var air_mask = $AltarImage/AirMaskImage
@onready var forrest_mask = $AltarImage/ForrestMaskImage

func _ready():
	interaction_area.body_entered.connect(_on_interaction_enter)
	interaction_area.body_exited.connect(_on_interaction_exit)
	proximity_area.body_entered.connect(_on_proximity_entered)
	proximity_area.body_exited.connect(_on_proximity_exit)

func _input(event: InputEvent) -> void:
	if player_in_range and event.is_action_pressed("interact") and !active_dialog:
		$Label.visible = false
		if player.is_on_floor():
			active_dialog = true
			if completed_altar:
				SignalBus.emit_signal("display_dialog", "completed_altar")
			else:
				if player.has_all_masks():
					complete_altar()
				else:
					SignalBus.emit_signal("display_dialog","altar_missing_mask")
	elif active_dialog and event.is_action_pressed("interact"):
		SignalBus.emit_signal("hide_dialog")
		active_dialog = false

func complete_altar():
	SignalBus.emit_signal("display_dialog","giving_masks_to_altar")
	$AltarVoll.visible = true
	
	
	completed_altar = true
	player.remove_masks_from_inventory()
	
	
func _on_interaction_enter(body: Node2D) -> void:
	if body.name == "Player":
		$Label.text = "Q"
		player = body
		player_in_range = true

func _on_interaction_exit(body: Node2D) -> void:
	if body.name == "Player":
		$Label.text = "?"
		player_in_range = false
	if completed_altar:
		$Label.visible = false


func _on_proximity_exit(body):
	$Label.visible = false
	if active_dialog:
		active_dialog = false
		SignalBus.emit_signal("hide_dialog")
		
func _on_proximity_entered(body: Node2D) -> void:
	if !completed_altar and body.name == "Player":
		$Label.text = "?"
		$Label.visible = true
