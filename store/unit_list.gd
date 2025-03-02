extends TabContainer

signal select

@onready var level1 : ItemList = get_node('Level 1')
@onready var level2 : ItemList = get_node('Level 2')

func _ready() -> void:
  level1.fixed_icon_size = Coord.grid_cell 
  level2.fixed_icon_size = Coord.grid_cell

  level1.item_selected.connect(on_level1_item_select)
  level2.item_selected.connect(on_level2_item_select)

  for key in Friendlies.level1:
    var unit = Friendlies.friendlies[key]
    assert(unit != null, 'All keys in Friendlies.level1 should be in Friendlies.friendlies')
    level1.add_item(unit['name'], unit['head_sprite'], true)
  
  for key in Friendlies.level2:
    var unit = Friendlies.friendlies[key]
    assert(unit != null, 'All keys in Friendlies.level2 should be in Friendlies.friendlies')
    level2.add_item(unit['name'], unit['head_sprite'], true)

func on_level1_item_select(idx : int) -> void:
  Sfx.play('SelectUnit')
  select.emit(Friendlies.friendlies[Friendlies.level1[idx]])

func on_level2_item_select(idx : int) -> void:
  Sfx.play('SelectUnit')
  select.emit(Friendlies.friendlies[Friendlies.level2[idx]])

func _on_tab_changed(_tab : int) -> void:
  Sfx.play('Select')
  level1.deselect_all()
  level2.deselect_all()
  Store.selected_panel_container.vbox_hide()