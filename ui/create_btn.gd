extends TextureButton

@export var unit_key: String

var tween_duration: float = 0.1
var tween_intensity: float = 1.1

func _ready() -> void:
  # Connect the signals for mouse enter and exit
  mouse_entered.connect(_on_mouse_entered)
  mouse_exited.connect(_on_mouse_exited)
  pressed.connect(create_at_selected)

  # Set the initial pivot offset to the center of the button
  pivot_offset = size / 2

func create_at_selected() -> void:
  if !State.is_selected:
    return
  Sfx.play('Click')
  if State.has_at_selected():
    State.at_selected().queue_free()
  Friendly.create(State.selected, unit_key)
  State.retrigger_select()

func start_tween(object: Object, property: String, final_val, duration: float):
  var tween = create_tween()
  tween.tween_property(object, property, final_val, duration)

func _on_mouse_entered():
  Sfx.play('Hover')
  start_tween(self, "scale", Vector2.ONE * tween_intensity, tween_duration)

func _on_mouse_exited():
  start_tween(self, "scale", Vector2.ONE, tween_duration)
