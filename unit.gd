class_name Unit extends Placeable

@export var body : Resource
@export var speed : int = 1
@export var max_size : int = 2
@export var abilities : Array[Ability] = []
@export var max_actions : int = 1

var actions_remaining: int = 1
var body_queue : Array[Body] = []

func _ready() -> void:
  moves = speed
  actions_remaining = max_actions
  State.phase_move.connect(func ():
    moves = speed
    actions_remaining = max_actions
  )
  super()

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
  if max_size > 1:
    var new_segment = body.instantiate()
    new_segment.index = from
    new_segment.parent = self
    State.add(from, new_segment)
    push_body_queue(new_segment)
    if !is_max_size():
      inc_size()
    else:
      var old_segment = pop_body_queue()
      State.remove(old_segment.index)
      old_segment.queue_free()

func take_damage(amount : int) -> void:
  for i in range(amount):
    size -= 1
    if size == 0:
      State.remove(index)
      queue_free()
      break
    var deleting = pop_body_queue()
    State.remove(deleting.index)
    deleting.queue_free()
    await get_tree().create_timer(0.1).timeout