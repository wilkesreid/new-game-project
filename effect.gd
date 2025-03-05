class_name Effect

var name: String
var lifespan: int
var turns_remaining: int
var parent: Placeable

var particles : GPUParticles2D
var particle_color : Color = Color(1, 1, 1, 1)

func _init(lfspn : int) -> void:
  lifespan = lfspn
  turns_remaining = lifespan

func start() -> void:
  particles = GPUParticles2D.new()
  particles.lifetime = .6
  particles.amount = 20
  particles.set_process_material(preload('res://shaders/particles/effect.tres'))
  particles.process_material.color = particle_color
  parent.add_child(particles)
func tick() -> void:
  pass
func end() -> void:
  particles.queue_free()
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
