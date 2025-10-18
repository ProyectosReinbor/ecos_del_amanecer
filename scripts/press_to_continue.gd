extends Control

# Esta función se activa con cualquier tipo de input que no haya sido manejado
func _unhandled_input(event):
	if event is InputEventKey or event is InputEventMouseButton:
		if event.is_pressed():
			# Cambia a la escena del menú principal
			get_tree().change_scene_to_file("res://scenes/menu.tscn")
