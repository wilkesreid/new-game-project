extends Resource
class_name Ability

@export var name : String
@export var distance : int = 1
@export var damage : int = 1
@export var needs_eyeline : bool = false

func on_button_pressed(unit : Unit) -> void:
  if unit.actions_remaining > 0:
    State.start_ability(self, unit)

func execute(target : Vector2i) -> void:
  State.ability_unit.actions_remaining -= 1
  var unit = State.at(target)
  if unit:
    if unit is Enemy:
      await unit.take_damage(damage)
    if unit is Body and unit.parent is Enemy:
      await unit.parent.take_damage(damage)
