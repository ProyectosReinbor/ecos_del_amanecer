extends Sprite2D

@export var area2D: Area2D;
@export var label_advertencia: Label;
@export var tipo_objeto: GameManager.Objetos = GameManager.Objetos.Hamaca;
@export var inventory: TextureRect;

var mensaje_recoger = "objeto (E)";
var puede_recoger = false;

func _ready():
	area2D.connect("body_entered", on_body_entered);
	area2D.connect("body_exited", on_body_exited);
	match tipo_objeto:
		GameManager.Objetos.Balas:
			mensaje_recoger = "bala (E)"
		GameManager.Objetos.Cuerda:
			mensaje_recoger = "cuerda (E)"
		GameManager.Objetos.Escopeta:
			mensaje_recoger = "escopeta (E)"
		GameManager.Objetos.Fosforos:
			mensaje_recoger = "fosforos (E)"
		GameManager.Objetos.Documentos:
			mensaje_recoger = "documentos (E)"
		GameManager.Objetos.Linterna:
			mensaje_recoger = "linterna (E)"
		GameManager.Objetos.Cuchillo:
			mensaje_recoger = "cuchillo (E)"
		GameManager.Objetos.Machete:
			mensaje_recoger = "machete (E)"
		GameManager.Objetos.Hayacas:
			mensaje_recoger = "hayacas (E)"
		GameManager.Objetos.Hamaca:
			mensaje_recoger = "hamaca (E)"


func _process(_delta: float) -> void:
	if Input.is_action_pressed("interact"):
		if puede_recoger:
			label_advertencia.text = ""
			puede_recoger = false
			GameManager.inventory.push_front(tipo_objeto)
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
