extends Area2D

@export var fail_message = ""
@export var trigger_count = 5
var fail_number = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	fail_number += 1
	if fail_number == trigger_count:
		SignalBus.emit_signal("show_message", fail_message)
