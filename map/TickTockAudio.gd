extends Node

var is_tick = false

func play():
	if is_tick:
		$TickPlayer.play()
		is_tick = false
	else:
		$TockPlayer.play()
		is_tick = true
