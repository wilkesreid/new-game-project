class_name Enemy extends Unit

func is_enemy() -> bool:
  return true

func _ready() -> void:
  State.add_existing_unit(index(), self)
