class_name Inventory_noche_fuego extends TextureRect

@export var objetos: Array[TextureRect] = [];
@export var seleccionado: TextureRect = null;
@export var seleccionado_sprite: TextureRect = null;
@export var objetos_texturas: Dictionary[GAME_MANAGER.Objetos, Texture2D] = {};
var indice_seleccionado: int = 0;
var last_size = 0;

func _ready():
	for i in range(0, objetos.size()):
		var tex = objetos[i]
		tex.connect("mouse_entered", func(): on_mouse_entered(tex));
		tex.connect("mouse_exited", func(): on_mouse_exited(tex));

func _process(_delta: float) -> void:
	if Input.is_key_pressed(KEY_1):
		on_mouse_entered(objetos[0]);
	elif Input.is_key_pressed(KEY_2):
		on_mouse_entered(objetos[1]);
	elif Input.is_key_pressed(KEY_3):
		on_mouse_entered(objetos[2]);
	elif Input.is_key_pressed(KEY_4):
		on_mouse_entered(objetos[3]);
	elif Input.is_key_pressed(KEY_5):
		on_mouse_entered(objetos[4]);
	elif Input.is_key_pressed(KEY_6):
		on_mouse_entered(objetos[5]);

func update_inventory():
	for i in range(0, GAME_MANAGER.inventory.size()):
		if (i >= objetos.size()):
			return
		var objeto = GAME_MANAGER.inventory[i]
		var tex = objetos[i]
		print(i, objeto, tex);
		tex.texture = objetos_texturas[objeto]

func on_mouse_entered(tex: TextureRect):
	if (tex == seleccionado):
		return ;
		
	seleccionado = tex;
	seleccionado_sprite.global_position = seleccionado.global_position - Vector2(1, 1);

func on_mouse_exited(tex: TextureRect):
	if (tex == seleccionado):
		seleccionado = null
		return
	seleccionado = null
	indice_seleccionado = 0
