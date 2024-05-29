extends Node3D

var delay = false
var state = false

signal state_set(state)

func set_state(get_state):
	state = get_state
	if get_state:
		$TestLever/AnimationPlayer.play("LeverPull")
		state_set.emit(get_state)
	else:
		$TestLever/AnimationPlayer.play_backwards("LeverPull")
		state_set.emit(get_state)

func _ready():
	$ObjectHandler.object_name = "puzzle_wrapper"

func _on_object_handler_activated():
	Global.input_hint_cleared.emit()

func _on_object_handler_triggered():
	if delay: return
	delay = true
	$DelayTimer.start()
	if !state:
		set_state(true)
		return
	else:
		set_state(false)

func _on_delay_timer_timeout():
	delay = false
