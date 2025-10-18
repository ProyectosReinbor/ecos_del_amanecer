extends Control
@export var opcionRio = "res://scenes/rio/rio.tscn"
@export var opcionMontana = "res://scenes/montana/montana.tscn"
func _on_rio_pressed() -> void:
	get_tree().change_scene_to_file(opcionRio)


func _on_montaña_pressed() -> void:
	get_tree().change_scene_to_file(opcionMontana)
