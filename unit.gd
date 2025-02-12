class_name Unit extends Placeable

var body : Resource
var speed : int = 1
var max_size : int = 2
var body_queue : Array[Body] = []

@export var abilities : Array[Ability] = []

func _ready() -> void:
  moves = speed
  State.on_set_phase(func (phase : State.PHASE) -> void:
    if phase == State.PHASE.MOVE:
      moves = speed
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

var moves : int = 1
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
    State.add(from, new_segment)
    push_body_queue(new_segment)
    if !is_max_size():
      inc_size()
    else:
      var old_segment = pop_body_queue()
      State.remove(old_segment.index)
      old_segment.queue_free()
