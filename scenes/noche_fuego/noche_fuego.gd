class_name Noche_fuego extends Node2D
@export var dialogo: Label;
@export var dialogos: Array[String] = [
	"[Sonidos de llano]",

	"[Teresa]: Mijo, va tocar vaya donde la comadre y pida panelita para un guandolo",
	"[Andrés]: Ay amá, ya voy tantico",
	"[Teresa]: Vaya a ver!!!",

	"[Narrador]: Un día normal, hasta que de pronto…",

	"[Tiroteo]",
	" *Llega niño aterrorizado* ",
	"[Andrés]: ¡Apa!, ¡Ama! una plomacera por el caño",
	"[Teresa]: Ay Dios mío Andrés ¿Qué pasó? ¿Por qué grita?",
	"[Andrés]: Se están dando bala aquí nomás!",

	"[José]: ¡Mijo, todos al piso rápido!",
	"[Carmen]: Ay que susto! Andrés qué vamos a hacer?",
	"[Andrés]: Agáchese amita que nos va a dar una bala perdida, agarre a luz",
	"*Luz Llora*",

	"[Miembro armado grita]: !Buenas tardes a todo el mundo!. Se le informa a la comunidad que por motivos de seguridad,deben abandonar el pueblo inmediatamente.",
	"[Miembro armado grita]: No nos hacemos responsable por la seguridad de ninguna persona que se encuentre aqui ni en los alrededores! Agradecemos la inmediata cooperación!",
	"[Carmen]: Ay señor! Qué vamos a hacer?.",
	"[Teresa]: Doña Carmen, pues irnos. Voy por los niños",
	"[José]: Empacar lo que podamos en esta maleta y salimos ya mismo",

	"[Narrador]: Los relámpagos clarean el llano, el aire trae olor a pólvora y monte quema´o. La guerra llegó a la puerta como un estruendo que retumba, no dio espera.",
	
	"[Teresa]: ¿Y los compadres del otro rancho?",
	"[José]: Ya no da tiempo pa´ buscarlos, mujer… nos fuimos pero ya..",
	
	"[Luz]: Papá tengo miedo.",
	"[Carmen]: Ay no qué susto!",
    "[Jose]: Toca decidir pronto: Nos vamos monte arriba o nos tiramos río abajo a la de Dios?"
];
@export var padre: CharacterBody2D;
@export var textures: Array[Texture2D] = [];
@export var texture_rect: TextureRect
@export var cinematica: Control;
@export var tiempo_restante_label: Label;
@export var ui_control: Control;
@export var decidir_camino_control: Control;
@export var musica_dia_tranquilo: AudioStream;
@export var audio_voces: AudioStreamPlayer;
@export var audios_voces: Array[AudioStream] = [];

var dialogo_actual: int = 0
var indice_parte_dialogo: int = 0
enum Estados {dialogos, buscar_items, dialogos_camino, decidir_camino}
var estado = Estados.dialogos;
var tiempo_restante = 20;

func _ready():
	MUSICA_FONDO.stream = musica_dia_tranquilo;
	MUSICA_FONDO.play();
	ui_control.visible = false;
	estado = Estados.dialogos;
	dialogo.text = "";
	texture_rect.texture = textures[0]
	padre.set_physics_process(false);

func tiroteo_dialogos():
	if (estado != Estados.dialogos):
		return ;
		
	indice_parte_dialogo = 0
	dialogo_actual += 1
	dialogo.text = "";
	if (dialogo_actual == 1):
		texture_rect.texture = textures[1]
	elif (dialogo_actual == 3):
		texture_rect.texture = textures[2]
	elif (dialogo_actual == 4):
		texture_rect.texture = textures[3]
	elif (dialogo_actual == 5):
		texture_rect.texture = textures[4]
	elif (dialogo_actual == 10):
		texture_rect.texture = textures[5]
	elif (dialogo_actual == 14):
		texture_rect.texture = textures[6]
	elif (dialogo_actual == 19):
		buscar_items();

func buscar_items():
	ui_control.visible = true;
	estado = Estados.buscar_items;
	GAME_MANAGER.inventory.clear();
	cinematica.visible = false;
	padre.set_physics_process(true);

func terminar_busqueda_items():
	estado = Estados.dialogos_camino;
	ui_control.visible = false;
	cinematica.visible = true;
	texture_rect.texture = textures[7]
	padre.set_physics_process(false);

func decision_camino_dialogos():
	if (estado != Estados.dialogos_camino):
		return ;
		
	indice_parte_dialogo = 0
	dialogo_actual += 1
	dialogo.text = "";
	if (dialogo_actual >= dialogos.size() - 1):
		estado_elegir_camino();
		return

	
func siguiente_dialogo():
	tiroteo_dialogos();
	decision_camino_dialogos();

func agregar_caracter():
	if estado != Estados.dialogos && Estados.dialogos_camino != estado:
		return

	var texto = dialogos[dialogo_actual]
	if (indice_parte_dialogo >= texto.length()):
		return
	var caracter = texto[indice_parte_dialogo]
	dialogo.text += caracter
	indice_parte_dialogo += 1

func terminar_dialogos_inicio():
	dialogo_actual = 19
	buscar_items();

func estado_elegir_camino():
	estado = Estados.decidir_camino;
	decidir_camino_control.visible = true;
	ui_control.visible = false;
	cinematica.visible = false;

func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		if (estado == Estados.dialogos):
			terminar_dialogos_inicio();

		elif estado == Estados.buscar_items:
			terminar_busqueda_items();

		elif estado == Estados.dialogos_camino:
			estado_elegir_camino();
			
	if Input.is_action_just_pressed("ui_accept"):
		siguiente_dialogo();

	if cinematica.visible:
		agregar_caracter();


func _on_segundos_timeout() -> void:
	if estado != Estados.buscar_items:
		return

	tiempo_restante -= 1;
	tiempo_restante_label.text = "tienes " + str(tiempo_restante) + " seg";
	if (tiempo_restante <= 0):
		terminar_busqueda_items();
