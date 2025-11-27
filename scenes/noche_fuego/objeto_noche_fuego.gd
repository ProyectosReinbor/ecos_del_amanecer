extends Sprite2D

@export var area2D: Area2D;
@export var label_advertencia: Label;
@export var tipo_objeto: GAME_MANAGER.Objetos = GAME_MANAGER.Objetos.Hamaca;
@export var inventory: TextureRect;

var mensaje_recoger = "objeto (E)";
var puede_recoger = false;

func _ready():
	area2D.connect("body_entered", on_body_entered);
	area2D.connect("body_exited", on_body_exited);
	match tipo_objeto:
		GAME_MANAGER.Objetos.Balas:
			mensaje_recoger = "bala (E)"
		GAME_MANAGER.Objetos.Cuerda:
			mensaje_recoger = "cuerda (E)"
		GAME_MANAGER.Objetos.Escopeta:
			mensaje_recoger = "escopeta (E)"
		GAME_MANAGER.Objetos.Fosforos:
			mensaje_recoger = "fosforos (E)"
		GAME_MANAGER.Objetos.Documentos:
			mensaje_recoger = "documentos (E)"
		GAME_MANAGER.Objetos.Linterna:
			mensaje_recoger = "linterna (E)"
		GAME_MANAGER.Objetos.Cuchillo:
			mensaje_recoger = "cuchillo (E)"
		GAME_MANAGER.Objetos.Machete:
			mensaje_recoger = "machete (E)"
		GAME_MANAGER.Objetos.Hayacas:
			mensaje_recoger = "hayacas (E)"
		GAME_MANAGER.Objetos.Hamaca:
			mensaje_recoger = "hamaca (E)"


func _process(_delta: float) -> void:
	if Input.is_action_pressed("interact"):
		if puede_recoger:
			label_advertencia.text = ""
			puede_recoger = false
			GAME_MANAGER.inventory.push_front(tipo_objeto)
			if inventory != null:
				inventory.update_inventory()
			queue_free()

func on_body_entered(body):
	if body.is_in_group("player"):
		label_advertencia.text = mensaje_recoger
		puede_recoger = true

func on_body_exited(body):
	if body.is_in_group("player"):
		if (label_advertencia.text == mensaje_recoger):
			label_advertencia.text = ""
		puede_recoger = false
