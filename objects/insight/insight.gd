extends Node3D

@export var object_name = "insight_test"
@export_multiline var dialogue_data: Array[String]
signal insight_activated

func _ready():
	$ObjectHandler.object_name = object_name

func _on_object_handler_activated():
	if Action.target != object_name: return
	Global.insight_pane_opened.emit(dialogue_data)
	Action.activate(object_name, false)
	Action.in_insight_dialogue = true
	Action.untargeted.emit()
	Global.can_move = false

func _on_object_handler_deactivated():
	if Action.last_target != object_name: return
	Global.insight_pane_closed.emit()
	Global.can_move = true
