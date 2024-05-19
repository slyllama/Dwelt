extends CanvasLayer

@export var fps_lower_limit = 20

func _ready():
	$Render.text = ""
	Global.debug_toggled.connect(func():
		visible = Global.debug_state)
	Global.debug_toggled.emit()

func _input(event):
	if (Input.is_action_just_pressed("toggle_debug")
		or Utilities.is_joy_button(event, JOY_BUTTON_BACK)):
		Global.debug_state = !Global.debug_state
		Global.debug_toggled.emit()

var i = 0
func _process(_delta):
	var colour = "green"
	$Details.text = str(Global.debug_details_text)
	var fps = Engine.get_frames_per_second()
	if fps < fps_lower_limit:
		colour = "red"
	$FPSCounter.text = ("[color=" + colour + "]"
		+ str(Engine.get_frames_per_second()) + "fps[/color]")
	
	# Only get render profiling data if the debugger is on (this is a little
	# more expensive). We also don't refresh this every frame
	if Global.debug_state == true:
		if i >= 10:
			var prim = Performance.get_monitor(
				Performance.RENDER_TOTAL_PRIMITIVES_IN_FRAME)
			var mem = Performance.get_monitor(
				Performance.RENDER_BUFFER_MEM_USED)
			$Render.text = "\nPrimitives: " + str(prim)
			$Render.text += "\nRender buffer: " + str(int(mem / 1000000)) + "MB"
			i = 0
	i += 1

func _mouseover(): Global.button_hover.emit()

func _on_print_save_data_pressed():
	print(Save.save_data)

func _on_save_pressed():
	Save.game_saved.emit()

func _on_reset_save_data_pressed():
	Save.reset_file()
	get_tree().change_scene_to_file("res://lib/loading/loading.tscn")
