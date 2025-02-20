extends Camera2D

var is_dragging : bool = false
var drag_start : Vector2
var position_at_drag : Vector2

func _process(_delta: float) -> void:
  if Input.is_action_just_pressed("camera_zoom_in"):
    zoom *= 1.1
  if Input.is_action_just_pressed("camera_zoom_out"):
    zoom *= 0.9
  if Input.is_action_just_pressed("camera_drag"):
    drag_start = DisplayServer.mouse_get_position()
    position_at_drag = position
    is_dragging = true
  if Input.is_action_just_released("camera_drag"):
    is_dragging = false
  
  if is_dragging:
    position = position_at_drag + (drag_start - Vector2(DisplayServer.mouse_get_position())) / zoom