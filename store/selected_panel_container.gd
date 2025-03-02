extends PanelContainer

@onready var label = $MarginContainer/VBoxContainer/Label
@onready var icon = $MarginContainer/VBoxContainer/HBoxContainer/TextureRect
@onready var grid = $MarginContainer/VBoxContainer/HBoxContainer/GridContainer
@onready var speed = grid.get_node('Speed')
@onready var max_size = grid.get_node('MaxSize')

func _ready():
	$MarginContainer/VBoxContainer.hide()
	Store.selected_panel_container = self

func display_unit(unit_data : Dictionary):
	label.text = unit_data['name']
	icon.texture = unit_data['head_sprite']
	speed.text = str(unit_data['speed'])
	max_size.text = str(unit_data['max_size'])

func vbox_hide():
	$MarginContainer/VBoxContainer.hide()

func vbox_show():
	$MarginContainer/VBoxContainer.show()