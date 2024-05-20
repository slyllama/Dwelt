extends Node3D

@export var object_name = "insight_test"
@export_multiline var dialogue_data: Array[String]
signal insight_activated

func _ready():
	$ObjectHandler.object_name = object_name

func _on_object_handler_activated():
	Global.insight_pane_opened.emit(dialogue_data)
	Action.activate(object_name, false)
	Action.in_insight_dialogue = true
	Action.untargeted.emit()

func _on_object_handler_deactivated():
	if Action.last_target == object_name:
		Global.insight_pane_closed.emit()

var count = 6
func _physics_process(_delta):
	if count == 0:
		if (Action.last_target != object_name): return
		count = 6 # don't do this every frame
		# Distance from the dialogue object to the player
		var distance = global_position.distance_to(Global.player_position)
		if distance > 5.0: $ObjectHandler.deactivate()
	count -= 1