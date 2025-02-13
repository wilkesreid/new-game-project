extends Control

var vflow : VFlowContainer

func _ready() -> void:
  vflow = get_node('PanelContainer/MarginContainer/VFlowContainer')
  remove_all_buttons()
  State.select.connect(_select)
  State.deselect.connect(_deselect)

func remove_all_buttons():
  for child in vflow.get_children():
    vflow.remove_child(child)
    child.queue_free()

func _select(index : Vector2i):
  remove_all_buttons()
  var unit = State.at(index)
  if unit != null and unit is Friendly:
    for ability in unit.abilities:
      var btn = Button.new()
      btn.text = ability.name
      vflow.add_child(btn)

func _deselect():
  remove_all_buttons()