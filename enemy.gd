class_name Enemy extends Unit

static func create(idx : Vector2i, data : Dictionary) -> Enemy:
  var enemy = Enemy.new(idx)
  enemy.set_stats(data)
  return enemy

func _init(idx : Vector2i):
  Enemies.active_enemies.append(self)
  Phase.on_enemy.connect(on_phase_enemy)
  super(idx)

func on_phase_enemy():
  moves = speed

func take_damage(damage : int) -> void:
  await super(damage)
  if size == 0:
    Enemies.remove(self)
