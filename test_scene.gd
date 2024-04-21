extends Node3D

func _fov_changed():
	%Player/CamPivot/CamArm/Camera.fov = Global.settings.fov
	save_settings() # TODO: streamline instead of having multiple functions

func _mute_changed():
	AudioServer.set_bus_mute(0, Global.settings.mute)
	save_settings()

func _blend_shadow_splits():
	$Sun.directional_shadow_blend_splits = Global.settings.blend_shadow_splits
	save_settings()

func save_settings(): # save settings to "settings.json" file
	var settings_json = FileAccess.open("user://settings.json", FileAccess.WRITE)
	settings_json.store_string(JSON.stringify(Global.settings))
	settings_json.close()

func _ready():
	# Load the settings file, or make a new one using save_settings() if it doesn't
	if FileAccess.file_exists("user://settings.json"):
		var settings_json = FileAccess.open("user://settings.json", FileAccess.READ)
		Global.settings = JSON.parse_string(settings_json.get_as_text())
		print("[InputSettings] 'settings.json' exists, loading.")
		settings_json.close()
	else:
		print("[InputSettings] 'settings.json' doesn't exist, creating it.")
		save_settings()
	
	# Apply settings and connect global changes
	Global.connect("fov_changed", _fov_changed)
	Global.emit_signal("fov_changed")
	Global.connect("mute_changed", _mute_changed)
	Global.emit_signal("mute_changed")
	Global.connect("blend_shadow_splits_changed", _blend_shadow_splits)
	Global.emit_signal("blend_shadow_splits_changed")
	
	$Ambience.volume_db = -20.0
	var ambi_tween = create_tween()
	ambi_tween.tween_property($Ambience, "volume_db", -3.0, 2.0).set_trans(Tween.TRANS_EXPO)
	await get_tree().create_timer(4.0).timeout
	$Music.play()
