class_name Effect

var name: String
var lifespan: int
var turns_remaining: int
var parent: Placeable

func _init(lfspn : int) -> void:
  lifespan = lfspn
  turns_remaining = lifespan

func start() -> void:
  pass
func tick() -> void:
  pass
func end() -> void:
  pass

func do_tick() -> void:
  await tick()
  turns_remaining -= 1
  if turns_remaining == 0:
    remove()

func apply(target: Placeable) -> void:
  parent = target
  target.effects.append(self)
  await start()

func remove() -> void:
  await end()
  parent.effects.erase(self)
  turns_remaining = lifespan
