class_name Unit extends Placeable

var sprite_body : Texture2D
var speed : int = 1
var max_size : int = 2
var body_queue : Array[Body] = []

func _init() -> void:
  moves = speed
  State.on_set_phase(func (phase : State.PHASE) -> void:
    if phase == State.PHASE.MOVE:
      moves = speed
  )

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

func index() -> Vector2i:
  return position

# assumes we're moving one step at a time
func move_to(target : Vector2) -> void:
  if moves == 0:
    return
  var from = position
  State.move(from, target)
  dec_moves()
  if max_size > 1:
    var new_segment = Body.new(from, sprite_body)
    State.add(from, new_segment)
    push_body_queue(new_segment)
    if !is_max_size():
      print('not max size yet, ', size, ' of ', max_size)
      inc_size()
    else:
      var old_segment = pop_body_queue()
      State.remove(old_segment.position)
