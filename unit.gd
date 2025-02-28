class_name Unit extends Placeable

var unit_name : String
var head_sprite : Resource
var body_sprite : Resource
# @export var body : Resource
@export var speed : int = 1
@export var max_size : int = 2
@export var abilities : Array[Ability] = []
@export var max_actions : int = 1

var sfx_move_file : FileAccess
var sfx_move_stream : AudioStreamWAV
var sfx_move_player : AudioStreamPlayer

var actions_remaining: int = 1
var body_queue : Array[Body] = []

func _init(idx : Vector2i) -> void:
  moves = speed
  actions_remaining = max_actions
  State.phase_move.connect(on_phase_move)
  super(idx)

func on_phase_move():
  moves = speed
  actions_remaining = max_actions

func _draw():
  draw_texture_rect(head_sprite, Rect2i(Vector2i(0, 0), Coord.grid_cell), false, Color(1, 1, 1, 1))

func set_stats(data):
  name = data['name'] # Built-in Godot names can't conflict
  unit_name = data['name']
  head_sprite = data['head_sprite']
  body_sprite = data['body_sprite']
  speed = data['speed']
  max_size = data['max_size']
  abilities.assign(data['abilities'])

func inc_speed() -> void:
  speed += 1

func is_max_size() -> bool:
  assert(size <= max_size)
  return size == max_size

var size : int = 1
func inc_size() -> void:
  size += 1

var moves : int = speed
func dec_moves() -> void:
  assert(moves >= 0)
  moves -= 1

# body queue
func pop_body_queue() -> Body:
  return body_queue.pop_front()
func push_body_queue(segment : Body) -> void:
  body_queue.push_back(segment)

# assumes we're moving one step at a time
func move_to(target : Vector2i) -> void:
  if moves == 0:
    return
  var from = index
  State.move(from, target)
  position = Coord.index_to_coord(target)
  dec_moves()
  Sfx.play('Move')
  if max_size > 1:
    # var new_segment = body.instantiate()
    var new_segment = Body.new(from, self)
    # new_segment.index = from
    # new_segment.parent = self
    State.add(from, new_segment)
    push_body_queue(new_segment)
    if !is_max_size():
      inc_size()
    else:
      var old_segment = pop_body_queue()
      State.remove(old_segment.index)
      old_segment.queue_free()

func take_damage(amount : int) -> void:
  await wait(0)
  if amount <= 0:
    return
  for i in range(amount):
    Sfx.play('Damage')
    size -= 1
    if size == 0:
      Sfx.play('Death')
      State.remove(index)
      queue_free()
      break
    var deleting = pop_body_queue()
    State.remove(deleting.index)
    deleting.queue_free()
    await get_tree().create_timer(State.game_speed).timeout