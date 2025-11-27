extends Timer
@export var texture1: TextureRect;
@export var texture2: TextureRect;
@export var texture3: TextureRect;

var indice = 0;
func _on_timeout() -> void:
	if indice == 0:
		texture1.visible = false;
	if indice == 1:
		texture2.visible = false;
	if (indice == 2):
		get_tree().change_scene_to_file("res://scenes/menu.tscn");
	indice += 1;