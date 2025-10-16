class_name AirMask
extends Mask

var prev_jump_v
var is_equipped = false

func get_mask_name():
	return "air_mask"
	
func apply(player):
	is_equipped = true
	prev_jump_v = player.JUMP_VELOCITY
	player.JUMP_VELOCITY  = -900
	
func remove(player):
	if is_equipped:
		player.JUMP_VELOCITY = prev_jump_v
