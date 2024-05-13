extends "res://lib/world_loader/world_loader.gd"

func _ready():
	super()
	$VentFan/AnimationPlayer.play("Fan")
	$Path3D/PathFollow3D/FourierTest/AnimationPlayer.play("Idle")

func _process(_delta):
	$Path3D/PathFollow3D.progress += 0.05
	if $Path3D/PathFollow3D.progress_ratio >= 0.99:
		$Path3D/PathFollow3D.progress = 0.0

func _on_fourier_visible_screen_entered():
	print("fourier IN")

func _on_fourier_visible_screen_exited():
	print("fourier OUT")
