extends CanvasLayer

func _toggle_interact_overlay(state):
	if state == true:
		var fade_tween = create_tween()
		fade_tween.tween_property($InteractOverlay, "modulate:a", 1.0, 0.2)
	else:
		var fade_tween = create_tween()
		fade_tween.tween_property($InteractOverlay, "modulate:a", 0.0, 0.2)

func _ready():
	Global.connect("interact_entered", _toggle_interact_overlay.bind(true))
	Global.connect("interact_left", _toggle_interact_overlay.bind(false))
	
	$InteractOverlay.modulate.a = 0.0
	
	# Present after a second
	await get_tree().create_timer(0.4).timeout
	$FadeOverlay.fade_in()
