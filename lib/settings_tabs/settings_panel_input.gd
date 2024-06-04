extends "res://lib/settings_tabs/settings_panel.gd"

const InputLine = preload("res://lib/ui/settings/components/stin_input_keybind.tscn")

var input_containers = [] # input list nodes, so they can be cleared on refresh

# Move the "reset" button to the bottom of the menu after reloading the menu
func _reset_to_bottom():
	$VBox.move_child($VBox/Default, -1)
	$VBox.move_child($VBox/Menu, -1)
	$VBox.move_child($VBox/Done, -1)

func _assign_controller_button(action, button):
	var e = InputEventJoypadButton.new()
	e.set_button_index(button)
	InputMap.action_add_event(action, e)

func apply_input_data():
	for i in Utilities.input_data:
		InputMap.action_erase_events(i.id)
		if i.type == "key":
			var e = InputEventKey.new()
			e.physical_keycode = i.code
			InputMap.action_add_event(i.id, e)
		elif i.type == "mouse":
			var e = InputEventMouseButton.new()
			e.button_index = i.code
			InputMap.action_add_event(i.id, e)
	
	# Set controller mappings
	_assign_controller_button("interact", JOY_BUTTON_A)
	_assign_controller_button("toggle_debug", JOY_BUTTON_BACK)
	_assign_controller_button("skill_ping", JOY_BUTTON_Y)

func refresh_input_data():
	Global.input_changed.emit()
	for node in input_containers: node.queue_free()
	input_containers = []
	save_input_data()
	
	# Update input map display
	for input in Utilities.input_data:
		var i = InputLine.instantiate()
		i.populate(input.name, input.id, Utilities.get_key(input.id))
		input_containers.append(i)
		$VBox.add_child(i)
	
	# Go to the bottom input from the close button
	#var LastInputButton = input_containers[input_containers.size() - 1].get_node("Button")
	#CloseButton.set_focus_neighbor(SIDE_TOP, CloseButton.get_path_to(LastInputButton))
	#
	# To avoid instantly triggering that input just by setting it
	# TODO: fix; this isn't that ideal...
	_reset_to_bottom()
	await get_tree().create_timer(0.2).timeout
	Global.in_keybind_select = false

func expand_input_data():
	for input in Utilities.input_data:
		var event = InputMap.action_get_events(input.id)[0]
		if event is InputEventMouseButton:
			input["type"] = "mouse"
			input["code"] = event.button_index
		elif event is InputEventKey:
			input["type"] = "key"
			input["code"] = event.physical_keycode

func save_input_data(): # save input data to "input_data.json" file
	expand_input_data()
	var inputs_json = FileAccess.open("user://input_data.json", FileAccess.WRITE)
	inputs_json.store_string(JSON.stringify(Utilities.input_data))
	inputs_json.close()

func _ready():
	super()
	expand_input_data()

	# Only do this once (from the loading screen)
	if Global.input_data_loaded == false:
		Global.original_input_data = Utilities.input_data.duplicate()
		if FileAccess.file_exists("user://input_data.json"):
			var inputs_file = FileAccess.open("user://input_data.json", FileAccess.READ)
			var inputs_json = JSON.parse_string(inputs_file.get_as_text())
			
			# TODO: better checking for input data validity
			Global.printc("[InputSettings] valid input_data.json exists, loading.")
			Utilities.input_data = inputs_json
			inputs_file.close()
		else:
			Global.printc("[InputSettings] input_data.json doesn't exist, creating it.")
			save_input_data()
		Global.input_data_loaded = true
	
	apply_input_data()
	Global.left_keybind_select.connect(func():
		refresh_input_data()
		$VBox/Done.grab_focus())
	refresh_input_data()

func _on_default_pressed():
	super()
	Utilities.input_data = Global.original_input_data.duplicate()
	apply_input_data()
	refresh_input_data()