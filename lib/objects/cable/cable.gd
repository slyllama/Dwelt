extends CSGCylinder3D

var start = Vector3(0.0, 0.0, 0.0)
var end = Vector3(1.0, 1.0, 1.0)

# Hide and show the end sphere -- could be updated with a better visual
# effect in the future
func toggle_end_point(state):
	if $Glow.visible != state:
		$Glow.visible = state

func update():
	global_position = (start + end) / 2.0
	look_at(end, Vector3.UP)
	rotation_degrees.x += 90.0
	
	height = global_position.distance_to(end) * 2.0
	$Sparks.look_at(end, Vector3.UP)
	$Sparks.position.y = height / 2.0
	$Glow.look_at(end, Vector3.UP)
	$Glow.position.y = height / 2.0
	
	material.set_shader_parameter("UVXScale", height * 0.02 + 3.0)

func _ready():
	# Avoid erroneous particles when the laser first updates its position
	await get_tree().create_timer(1.0).timeout
	$Sparks.emitting = true

func _process(_delta):
	update()