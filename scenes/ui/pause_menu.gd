extends Control

func pause():
	get_tree().paused = true
	visible = true
	
func resume():
	get_tree().paused = false
	visible =false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("esc") and get_tree().paused == false:
		pause()
	elif event.is_action_pressed("esc") and get_tree().paused == true:
		resume()
		

		


func _on_resume_button_pressed() -> void:
	resume()


func _on_restart_button_pressed() -> void:
	resume()
	get_tree().reload_current_scene()
	


func _on_quit_button_pressed() -> void:
	get_tree().quit()
