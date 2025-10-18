class_name Padre_noche_fuego extends CharacterBody2D

@export var velocidad_caminar := 50.0
@export var velocidad_correr := 100.0

var direccion := Vector2.ZERO
var corriendo := false

@export var anim: AnimatedSprite2D;
@export var area_mount: Area2D;
@export var collisionShape2D: CollisionShape2D;

var objeto_para_recoger: Sprite2D = null
enum Estados {idle, walk, run, recolectar}
var estado: Estados = Estados.idle

func _ready():
	add_to_group("player");
	area_mount.connect("body_entered", on_body_entered);
	area_mount.connect("body_exited", on_body_exited);

func input_direccion():
	direccion = Vector2.ZERO

	if Input.is_action_pressed("ui_up"):
		direccion.y -= 1
	if Input.is_action_pressed("ui_down"):
		direccion.y += 1
	if Input.is_action_pressed("ui_left"):
		direccion.x -= 1
	if Input.is_action_pressed("ui_right"):
		direccion.x += 1
	
	direccion = direccion.normalized()

func input_correr():
	return Input.is_action_pressed("correr");


func _physics_process(_delta: float) -> void:
	if estado == Estados.recolectar:
		return

	if Input.is_action_just_pressed("interact"):
		if objeto_para_recoger != null:
			estado = Estados.recolectar
			objeto_para_recoger = null
			return ;

	input_direccion();
	var velocidad_actual = velocidad_correr if input_correr() else velocidad_caminar
	velocity = direccion * velocidad_actual
	move_and_slide();
	_actualizar_animacion()

func _actualizar_animacion():
	if direccion == Vector2.ZERO:
		estado = Estados.idle
	elif corriendo:
		estado = Estados.run
	else:
		estado = Estados.walk

	var dir_anim = ""

	if direccion == Vector2.ZERO:
		dir_anim = _obtener_direccion_idle()
	else:
		if abs(direccion.x) > abs(direccion.y):
			dir_anim = "side"
			anim.flip_h = direccion.x < 0
		elif direccion.y < 0:
			dir_anim = "up"
		else:
			dir_anim = "down"

	anim.play(get_text_estado() + dir_anim)

func get_text_estado() -> String:
	match estado:
		Estados.idle:
			return "idle_"
		Estados.walk:
			return "walk_"
		Estados.run:
			return "run_"
		Estados.recolectar:
			return "collect_"
	return "";


func _obtener_direccion_idle() -> String:
	var anim_actual = anim.animation
	if "up" in anim_actual:
		return "up"
	elif "down" in anim_actual:
		return "down"
	else:
		return "side"


func on_body_entered(body):
	if body.is_in_group("objeto"):
		objeto_para_recoger = body

func on_body_exited(body):
	if body == objeto_para_recoger:
		objeto_para_recoger = null