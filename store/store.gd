class_name Store extends Node2D

static var selected_panel_container : PanelContainer

func on_unit_select(unit_data : Dictionary):
	selected_panel_container.vbox_show()
	selected_panel_container.display_unit(unit_data)