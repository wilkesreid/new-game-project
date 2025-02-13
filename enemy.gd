class_name Enemy extends Unit

func _ready():
  Enemies.enemies.append(self)
  State.phase_enemy.connect(func ():
    moves = speed
  )
  super()

func take_damage(damage : int) -> void:
  await super(damage)
  if size == 0:
    Enemies.remove(self) 