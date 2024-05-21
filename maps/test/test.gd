extends "res://lib/world_loader/world_loader.gd"

func _ready():
	super()
	Global.debug_state = true
	Global.debug_toggled.emit()
	
	%Sky.environment.volumetric_fog_enabled = false

	Save.save_loaded.connect(func():
		if Save.get_data(map_name, "laser_kopa_orientation") != null:
			$Laser/Cast.rotation_degrees = Save.get_data(map_name, "laser_kopa_orientation"))

	Save.load_from_file()

func _input(_event):
	if Input.is_action_just_pressed("debug_action"):
		if $VentHandler.is_running:
			$VentHandler.turn_off()
			return
		else: $VentHandler.turn_on()

func _on_laser_player_left(object_name, cast_rotation_degrees):
	Save.set_data(map_name, "laser_" + object_name + "_orientation", cast_rotation_degrees)
