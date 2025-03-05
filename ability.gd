class_name Ability

var name : String
var description : String
var distance : int = 1
var damage : int = 1
var do : Callable

func _init(data : Dictionary) -> void:
  name = data['name']
  if data.has('description'):
    description = data['description']
  distance = data['distance']
  damage = data['damage']
  if data.has('do'):
    do = data['do']

func gui_input(event : InputEvent, unit : Unit) -> void:
  if event.is_action_pressed('click'):
    if unit.actions_remaining > 0:
      Sfx.play('Click')
      State.start_ability(self, unit)

func execute(target : Vector2i) -> void:
  assert(State.ability_unit is Placeable, 'tried to execute ability, but ability_unit is not valid. ability may have been ended before trying to execute')
  State.ability_unit.actions_remaining -= 1
  var unit = State.at(target)
  if unit:
    if do:
      if unit is Body:
        await do.call(unit.parent)
      elif unit is Unit:
        await do.call(unit)
    elif ability_may_damage(unit):
      await unit.take_damage(damage)
    elif ability_may_damage_body(unit):
      await unit.parent.take_damage(damage)
  State.end_ability()

func ability_may_damage(unit : Placeable) -> bool:
  return (unit is Enemy and State.ability_unit is Friendly) or (unit is Friendly and State.ability_unit is Enemy)

func ability_may_damage_body(body : Placeable) -> bool:
  return (body is Body and (
    (State.ability_unit is Friendly and body.parent is Enemy)
    or (State.ability_unit is Enemy and body.parent is Friendly)
  ))
