class_name Unit extends Node2D

@export var bodytexture : Texture2D

# each subclass of unit will need
# to define its own resource it uses,
# which should refer to the tscn it's
# attached to
var rs : Resource

func _ready() -> void:
  if State.unit_at(index()) != self:
    State.add_existing_unit(index(), self)
  if is_head():
    moves = speed
    State.on_set_phase(func (phase : State.PHASE) -> void:
      if phase == State.PHASE.MOVE:
        moves = speed
    )

# Overridable
func is_enemy() -> bool:
  return false

var _is_head : bool = true
func is_head() -> bool:
  return _is_head
func set_is_head(val : bool) -> void:
  _is_head = val

var speed : int = 1
func inc_speed() -> void:
  speed += 1

var max_size : int = 2
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
var body_queue : Array[Node2D] = []
func pop_body_queue() -> Node2D:
  return body_queue.pop_front()
func push_body_queue(segment : Node2D) -> void:
  body_queue.push_back(segment)

func make_body() -> void:
  set_is_head(false)
  $Sprite2D.texture = bodytexture

func index() -> Vector2i:
  return Coord.coord_to_index(position)

# assumes we're moving one step at a time
func move_to_index(target : Vector2) -> void:
  if moves == 0:
    return
  var old_position = position
  var old_index = index()
  State.unit_move_index(index(), target)
  position = Coord.index_to_coord(target)
  dec_moves()
  if max_size > 1:
    var new_segment = duplicate(DuplicateFlags.DUPLICATE_USE_INSTANTIATION)
    new_segment.set_position(old_position)
    new_segment.make_body()
    State.add_unit(old_index, new_segment)
    push_body_queue(new_segment)
    if !is_max_size():
      print('not max size yet, ', size, ' of ', max_size)
      inc_size()
    else:
      var old_segment = pop_body_queue()
      State.remove_unit(old_segment.index())
