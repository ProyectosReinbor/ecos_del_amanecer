extends Control
@export var opcionMontana = "res://scenes/reten/reten.tscn"

func _on_montaña_pressed() -> void:
	get_tree().change_scene_to_file(opcionMontana)
