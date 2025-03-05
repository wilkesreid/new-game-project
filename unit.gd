class_name Unit extends Placeable

var unit_name : String
var head_sprite : Resource
var body_sprite : Resource
var max_size : int = 2
var abilities : Array[Ability] = []
var max_actions : int = 1

var _speed : int = 1
var speed : int:
  get:
    return _speed
  set(value):
    _speed = value
    moves = value

var actions_remaining: int = 1
var body_queue : Array[Body] = []

func _init(idx : Vector2i) -> void:
  moves = speed
  actions_remaining = max_actions
  Phase.on_move.connect(on_phase_move)
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
    var new_segment = Body.new(from, self)
    State.add(from, new_segment)
    body_queue.push_front(new_segment)
    if !is_max_size():
      inc_size()
    else:
      var old_segment = body_queue.pop_back()
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
    var deleting = body_queue.pop_back()
    State.remove(deleting.index)
    deleting.queue_free()
    await get_tree().create_timer(State.game_speed).timeout


func add_body_at_end(at : Vector2i) -> void:
  var new_segment = Body.new(at, self)
  State.add(at, new_segment)
  body_queue.push_back(new_segment)
  inc_size()

func heal(amount : int) -> void:
  var do_heal = func(at : Vector2i):
    add_body_at_end(at)
    Sfx.play('Heal')
    await get_tree().create_timer(State.game_speed).timeout
  
  for _i in range(amount):
    if is_max_size():
      return

    var target_index : Vector2i

    # Step 1: Do we have any body segments, or only a head? If
    # we only have a head, then we can create a new body segment
    # in any adjacent spot, if one exists. If none exist, this
    # unit is entirely trapped anyway, so no healing
    if size == 1:
      target_index = Vector2i(index.x, index.y - 1)
      if !State.has(target_index):
        await do_heal.call(target_index)
        continue
      target_index = Vector2i(index.x + 1, index.y)
      if !State.has(target_index):
        await do_heal.call(target_index)
        continue
      target_index = Vector2i(index.x, index.y + 1)
      if !State.has(target_index):
        await do_heal.call(target_index)
        continue
      target_index = Vector2i(index.x - 1, index.y)
      if !State.has(target_index):
        await do_heal.call(target_index)
        continue
      continue
  
    # Step 2: We have at least one body segment. We need to
    # find the last body segment, and then try to create a
    # new body segment adjacent to it. If we can't, then we
    # need to try the next body segment, and so on, until we
    # reach the head.
    var cur_segment : Placeable = null
    var cur_index : int = body_queue.size() - 1
    var did_add : bool = false
    while cur_index >= 0:
      cur_segment = body_queue[cur_index]
      var cur_segment_index = cur_segment.index
  
      # try x opposite the head
      var xdir = 1 if (cur_segment_index.x - index.x) > 0 else -1
      var ydir = 1 if (cur_segment_index.y - index.y) > 0 else -1
      if (cur_segment_index.y - index.y) == 0:
        target_index = Vector2i(cur_segment_index.x + xdir, cur_segment_index.y)
        if !State.has(target_index):
          await do_heal.call(target_index)
          did_add = true
          break
        target_index = Vector2i(cur_segment_index.x - xdir, cur_segment_index.y)
        if !State.has(target_index):
          await do_heal.call(target_index)
          did_add = true
          break
      elif (cur_segment_index.x - index.x) == 0:
        target_index = Vector2i(cur_segment_index.x, cur_segment_index.y + ydir)
        if !State.has(target_index):
          await do_heal.call(target_index)
          did_add = true
          break
        target_index = Vector2i(cur_segment_index.x, cur_segment_index.y - ydir)
        if !State.has(target_index):
          await do_heal.call(target_index)
          did_add = true
          break
      else:
        target_index = Vector2i(cur_segment_index.x, cur_segment_index.y + ydir)
        if !State.has(target_index):
          await do_heal.call(target_index)
          did_add = true
          break
        target_index = Vector2i(cur_segment_index.x + xdir, cur_segment_index.y)
        if !State.has(target_index):
          await do_heal.call(target_index)
          did_add = true
          break
        target_index = Vector2i(cur_segment_index.x, cur_segment_index.y - ydir)
        if !State.has(target_index):
          await do_heal.call(target_index)
          did_add = true
          break
        target_index = Vector2i(cur_segment_index.x - xdir, cur_segment_index.y)
        if !State.has(target_index):
          await do_heal.call(target_index)
          did_add = true
          break
        cur_index -= 1 
    
    if did_add:
      continue
  
    # Step 3: If we've gotten this far, we have at least one body segment,
    # but nowhere along the body to place our new part. So we need to basically
    # do step 1, which we skipped because we already had a body segment.
    target_index = Vector2i(index.x, index.y - 1)
    if !State.has(target_index):
      await do_heal.call(target_index)
      continue
    target_index = Vector2i(index.x + 1, index.y)
    if !State.has(target_index):
      await do_heal.call(target_index)
      continue
    target_index = Vector2i(index.x, index.y + 1)
    if !State.has(target_index):
      await do_heal.call(target_index)
      continue
    target_index = Vector2i(index.x - 1, index.y)
    if !State.has(target_index):
      await do_heal.call(target_index)
      continue
    continue