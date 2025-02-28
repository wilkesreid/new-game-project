extends Control

var vflow : VFlowContainer

func _ready() -> void:
  vflow = $PanelContainer/MarginContainer/VFlowContainer
  remove_all()
  State.select.connect(_select)
  State.deselect.connect(_deselect)

func remove_all():
  for child in vflow.get_children():
    vflow.remove_child(child)
    child.queue_free()

func _select(index : Vector2i):
  remove_all()
  var unit = State.at(index)
  if unit != null:
    
    # Name
    var name_label = Label.new()
    name_label.text = unit.unit_name
    vflow.add_child(name_label)

    # Speed
    var speed_label = Label.new()
    speed_label.text = 'Speed: ' + str(unit.speed)
    vflow.add_child(speed_label)

    # Max Size
    var max_size_label = Label.new()
    max_size_label.text = 'Max Size: ' + str(unit.max_size)
    vflow.add_child(max_size_label)

    vflow.add_child(HSeparator.new())

    for ability in unit.abilities:
      if unit is Friendly:
        var btn = Button.new()
        btn.text = ability.name
        btn.action_mode = Button.ACTION_MODE_BUTTON_PRESS
        btn.mouse_filter = Button.MOUSE_FILTER_STOP
        btn.connect('gui_input', func (event : InputEvent):
          ability.gui_input(event, unit)
        )
        vflow.add_child(btn)
      else: # Name
        var ability_name_label = Label.new()
        ability_name_label.text = ability.name
        vflow.add_child(ability_name_label)

      # Range
      var ability_range_label = Label.new()
      ability_range_label.text = 'Range: ' + str(ability.distance)
      vflow.add_child(ability_range_label)

      # Damage
      var ability_damage_label = Label.new()
      ability_damage_label.text = 'Damage: ' + str(ability.damage)
      vflow.add_child(ability_damage_label)

func _deselect():
  remove_all()