extends Area3D
# object_handler.gd
# A generic object handler. it looks out for action events and fires signals
# which can be used by its parent class. The aim here is to provide a single
# object handler for every kind of action - dialogue, machines, elevators etc.

## This object name is used by the action handler and must be specified by the
## parent scene.
@export var object_name = "none"
@export var cube_size = 3.0
@export var can_toggle_action = true

signal activated
signal deactivated
var active = false

func _interact():
	if Action.target == object_name:
		if Action.active == false and active == false:
			Utilities.enter_action(object_name, can_toggle_action)
			active = true
			activated.emit()
			return
	if active == true:
		Utilities.leave_action()
		active = false
		deactivated.emit()
		return

func _ready():
	Global.skill_clicked.connect(func(skill_name):
		if skill_name == "interact": _interact())
	$Collision.shape.set_size(Vector3(cube_size, cube_size, cube_size))

func _input(_event):
	if Input.is_action_just_pressed("interact"): _interact()