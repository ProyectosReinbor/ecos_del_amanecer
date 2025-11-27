extends Control
@export var canvas_modulate: CanvasModulate;
@export var light: PointLight2D;
@export var dialogo: Label;
@export var dialogos: Array[String] = [
	"Encuentra a Don Eusebio en las orillas del río, negocia con él por un barco.",
	"[Don Eusebio]: ¿Van cruzando?",
	"[José]: Sí don, ¿nos puede pasar?",
	"[Don Eusebio]: El río está bravo. Son 300 pesos.",
	"Pierdes documentos, Don Eusebio te lleva por 300 pesos.",
	"[José]: no tenemos 300 pesos, Don Eusebio ayudanos a cruzar el río.",
	"[Don Eusebio]: De acuerdo. Te llevare por 150 pesos y una escopeta, el bosque es peligroso.",
	"Pierdes escopeta, Don Eusebio te lleva por 150 pesos.",
	"[Teresa]: ¿Qué hacemos?",
	"[José]: Hay que cruzar el río.",
	"[Don Eusebio]: Están locos. Allá ustedes.",
];
@export var padre: CharacterBody2D;
@export var textures: Array[Texture2D] = [];
@export var texture_rect: TextureRect
@export var cinematica: Control;
@export var ui_control: Control;
@export var decidir_camino_control: Control;

var dialogo_actual: int = 0
var indice_parte_dialogo: int = 0
enum Estados {dialogos, buscar_don_eusebio, dialogos_negociacion, decidir_camino}
var estado = Estados.dialogos;
var tiempo_restante = 20;
var se_va_con_don_eusebio = false;

func _ready():
	decidir_camino_control.visible = false;
	ui_control.visible = false;
	estado = Estados.dialogos;
	dialogo.text = "";
	texture_rect.texture = textures[0]
	padre.set_physics_process(false);
	canvas_modulate.visible = false;
	light.visible = false;

func buscar_don_eusebio():
	if (estado != Estados.dialogos):
		return ;
	
	canvas_modulate.visible = true;
	light.visible = true;
	dialogo_actual = 1;
	estado = Estados.buscar_don_eusebio;
	ui_control.visible = true;
	cinematica.visible = false;
	decidir_camino_control.visible = false;
	padre.set_physics_process(true);

func dialogos_mision():
	if (estado != Estados.dialogos && Estados.dialogos_negociacion != estado):
		return ;

	indice_parte_dialogo = 0
	dialogo_actual += 1
	dialogo.text = "";
	if (se_va_con_don_eusebio):
		cambiar_escena();

	if (dialogo_actual == 1):
		buscar_don_eusebio();
	if (dialogo_actual == 5):
		if (GAME_MANAGER.inventory.find(GAME_MANAGER.Objetos.Documentos) != -1):
			GAME_MANAGER.inventory.erase(GAME_MANAGER.Objetos.Documentos)
			se_va_con_don_eusebio = true;
		else:
			dialogo_actual += 1;
			dialogos_mision();
	elif (dialogo_actual == 7):
		if (GAME_MANAGER.inventory.find(GAME_MANAGER.Objetos.Escopeta) != -1):
			GAME_MANAGER.inventory.erase(GAME_MANAGER.Objetos.Escopeta)
			se_va_con_don_eusebio = true;
		else:
			dialogo_actual += 1;
			dialogos_mision();
	
	GAME_MANAGER.dead_members()
	GAME_MANAGER.dead_members()
	if (GAME_MANAGER.game_state == "Game_Over"):
		get_tree().change_scene_to_file("res://scenes/game_over/game_over.tscn")

	
func siguiente_dialogo():
	dialogos_mision();

func agregar_caracter():
	if estado != Estados.dialogos && Estados.dialogos_negociacion != estado:
		return

	var texto = dialogos[dialogo_actual]
	if (indice_parte_dialogo >= texto.length()):
		return
	var caracter = texto[indice_parte_dialogo]
	dialogo.text += caracter
	indice_parte_dialogo += 1

func negociar_barco_estado():
	canvas_modulate.visible = false;
	light.visible = false;
	estado = Estados.dialogos_negociacion;
	ui_control.visible = false;
	decidir_camino_control.visible = false;
	cinematica.visible = true;
	texture_rect.texture = textures[1]
	padre.set_physics_process(false);

func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		if (estado == Estados.dialogos):
			buscar_don_eusebio();
			
	if Input.is_action_just_pressed("ui_accept"):
		siguiente_dialogo();

	if cinematica.visible:
		agregar_caracter();


func _on_rio_pressed() -> void:
	negociar_barco_estado();

func cambiar_escena() -> void:
	get_tree().change_scene_to_file("res://san_martin.tscn")


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		estado = Estados.decidir_camino
		decidir_camino_control.visible = true;
		ui_control.visible = false;
		cinematica.visible = false;
