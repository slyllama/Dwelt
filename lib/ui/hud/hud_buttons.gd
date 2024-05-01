extends CanvasLayer

signal settings_pressed
var faded = false

func _on_debug_button_pressed():
	Global.debug_state = !Global.debug_state
	Global.debug_toggled.emit()
func _on_settings_button_pressed():
	settings_pressed.emit()
func _mouseover():
	Global.button_hover.emit()

func fade_out():
	$Delay.start()
	await $Delay.timeout
	
	faded = true
	var fade_tween = create_tween()
	fade_tween.tween_property($TopMenu, "modulate:a", 0.0, 0.2)
	fade_tween.tween_callback(func(): if faded == true: visible = false)

func fade_in():
	$Delay.stop()
	faded = false
	visible = true
	var fade_tween = create_tween()
	fade_tween.tween_property($TopMenu, "modulate:a", 1.0, 0.2)

func _ready():
	Global.mouse_captured.connect(fade_out)
	Global.mouse_released.connect(fade_in)