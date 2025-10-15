extends CanvasLayer

@export_file("*.json") var scene_text_file: String
var scene_text = {}
@onready var text_label = $NinePatchRect/MarginContainer/RichTextLabel
@onready var background = $NinePatchRect

var in_progress = false

func _ready():
	SignalBus.connect("display_dialog", on_display_dialog)
	SignalBus.connect("hide_dialog", on_hide_dialog)
	if scene_text_file != "":
		var file = FileAccess.open(scene_text_file, FileAccess.READ)
		scene_text = JSON.parse_string(file.get_as_text())
	background.visible = false
	
func on_hide_dialog():
	background.visible = false
	
func on_display_dialog(text_key):
	in_progress = true
	var text = scene_text[text_key]
	background.visible = true
	text_label.text = text
