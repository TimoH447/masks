class_name FireMask
extends Mask

var prev_jump_v
var is_equipped = false

func get_mask_name():
	return "fire_mask"
	
func apply(player):
	is_equipped = true
	player.has_fire_mask = true
	player.get_node("PointLight2D").enabled = true
	
func remove(player):
	if is_equipped:
		player.has_fire_mask = false
		player.get_node("PointLight2D").enabled = false
