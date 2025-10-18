extends TextureRect
var indice = 0;
@export var logos: Array[Texture];


func _on_timer_timeout() -> void:
	if (indice == logos.size()):
		return ;
	self.texture = logos[indice];
	indice += 1;
	if (indice >= logos.size()):
		self.visible = false;
