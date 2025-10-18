extends Node2D
@export var camera_2d: Camera2D
@export var padre: Player
@export var madre: Player
@export var hijo: Player
@export var hija: Player
@export var abuelo: Player

enum Personaje {MADRE, PADRE, HIJO, HIJA, ABUELO}
var personaje_control: Personaje = Personaje.HIJO;
var personaje_lider: Player

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_focus_next"):
		if personaje_control == Personaje.HIJO:
			personaje_control = Personaje.HIJA
		elif personaje_control == Personaje.HIJA:
			personaje_control = Personaje.MADRE
		elif personaje_control == Personaje.MADRE:
			personaje_control = Personaje.PADRE
		elif personaje_control == Personaje.PADRE:
			personaje_control = Personaje.ABUELO
		elif personaje_control == Personaje.ABUELO:
			personaje_control = Personaje.HIJO
		cambiar_camara()

func _ready() -> void:
	personaje_lider = hijo
	cambiar_camara()
	
func cambiar_camara():
	if camera_2d.get_parent():
		camera_2d.get_parent().remove_child(camera_2d)
		
	match personaje_control:
		Personaje.PADRE:
			personaje_lider = padre
		Personaje.MADRE:
			personaje_lider = madre
		Personaje.HIJO:
			personaje_lider = hijo
		Personaje.HIJA:
			personaje_lider = hija
		Personaje.ABUELO:
			personaje_lider = abuelo

	# Reasigna la cámara
	hijo.es_personaje_lider = false;
	hijo.personaje_lider = personaje_lider
	hija.es_personaje_lider = false;
	hija.personaje_lider = personaje_lider
	padre.es_personaje_lider = false;
	padre.personaje_lider = personaje_lider
	madre.es_personaje_lider = false;
	madre.personaje_lider = personaje_lider
	abuelo.es_personaje_lider = false;
	abuelo.personaje_lider = personaje_lider
	
	personaje_lider.add_child(camera_2d)
	personaje_lider.es_personaje_lider = true
	personaje_lider.personaje_lider = null
	camera_2d.position = Vector2.ZERO
	camera_2d.make_current()
