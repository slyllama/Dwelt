extends TextureButton

## Whether the skill can be used.
@export var enabled = true
## Passed to the 'Global.skill_clicked' signal and listened to by others.
@export var skill_name = "empty"
@export var input_mapping = "none"
@export var initial_texture = "UNKNOWN"

const textures = {
	"UNKNOWN": preload("res://lib/ui/skills/tex/unknown.png"),
	"CANCEL": preload("res://lib/ui/skills/tex/cancel.png"),
	"LOCKED": preload("res://lib/ui/skills/tex/locked.png")
}

func enable():
	enabled = true
	$Icon.modulate.a = 1.0

func disable():
	enabled = false
	self_modulate.a = 0.4
	$Icon.modulate.a = 0.2

func set_texture(tex_name):
	if !tex_name in textures: return
	$Icon.texture = textures[tex_name]

# Updates the input command that shows on the bottom right of the button
func _get_key():
	if input_mapping != "none":
		$InputKey.text = "[center]" + Utilities.get_key(input_mapping) + "[/center]"
	else: $InputKey.visible = false

func _ready():
	disable() # disabled by default
	_get_key()
	self_modulate.a = 0.4
	Global.input_changed.connect(_get_key)
	
	set_texture(initial_texture)

func _mouse_entered():
	if enabled == false: return
	Global.button_hover.emit()
	Global.button_hover.emit()
	self_modulate.a = 1.0

func _mouse_left(): self_modulate.a = 0.4

func _on_pressed():
	if enabled == false: return
	Global.skill_clicked.emit(skill_name)
