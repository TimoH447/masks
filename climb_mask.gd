class_name ClimbMask
extends Mask

var prev_jump_v
var is_equipped = false

func get_mask_name():
	return "forrest_mask"
	
func apply(player):
	is_equipped = true
	player.has_wall_jump_ability = true
	
func remove(player):
	if is_equipped:
		player.has_wall_jump_ability = false
