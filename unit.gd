extends Node2D

@export var bodytexture : Texture2D

var is_head : bool = true
var speed : int = 1;
var max_size : int = 2;
var size : int = 1;

var body_queue : Array[Node2D] = []

func make_body() -> void:
  is_head = false
  $Sprite2D.texture = bodytexture

func index() -> Vector2i:
  return Coord.coord_to_index(position)

# assumes we're moving one step at a time
func move_to_index(target : Vector2) -> void:
  var old_position = position
  var old_index = index()
  State.unit_move_index(index(), target)
  position = Coord.index_to_coord(target)
  if max_size > 1:
    var new_segment = duplicate(DuplicateFlags.DUPLICATE_USE_INSTANTIATION)
    new_segment.set_position(old_position)
    new_segment.make_body()
    get_tree().root.add_child(new_segment)	
    State.add_unit(old_index, new_segment)
    body_queue.push_back(new_segment)
    if size < max_size:
      size += 1
    else:
      var old_segment = body_queue.pop_front()
      State.remove_unit(old_segment.index())
