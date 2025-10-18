class_name Horse extends CharacterBody2D

@export var animated_sprite_2d: AnimatedSprite2D = null
@export var area_2d_mount: Area2D = null

var rider: Player = null;
var speed_walk := 60.0
var speed_run := 120.0
var direction := Vector2.ZERO
var is_mounted := false
var health := 100
var player_in_range := false
var timerToStand = Timer.new();
var can_stand = false;
var stand_animation_played = false;

func _ready() -> void:
	add_to_group("horse");
	area_2d_mount.body_entered.connect(_on_area_entered);
	area_2d_mount.body_exited.connect(_on_area_exited);
	
	add_child(timerToStand)
	timerToStand.one_shot = true
	timerToStand.wait_time = 0.5
	timerToStand.timeout.connect(end_timer_to_stand)

func _on_area_entered(body):
	if body.is_in_group("player") and body.vida_actual > 0:
		rider = body
		player_in_range = true

func _on_area_exited(body):
	if body == rider:
		player_in_range = false

func _physics_process(_delta):
	if health <= 0:
		_set_anim_direction("death")
		return

	if (Input.is_action_just_pressed("interact")):
		if is_mounted: # tecla E
			_dismount()
		elif player_in_range:
			_mount()

	if is_mounted:
		rider.input_direccion();
		move_mounted()
		move_and_slide()
	else:
		velocity = Vector2.ZERO


func _mount():
	is_mounted = true
	rider.set_physics_process(false);
	rider.collisionShape2D.disabled = true

func _dismount():
	is_mounted = false;
	rider.set_physics_process(true);
	rider.collisionShape2D.disabled = false

func end_timer_to_stand():
	can_stand = false;
	timerToStand.stop()

func move_mounted():
	if not is_mounted:
		return
	
	if Input.is_action_just_released("correr") && !can_stand:
		can_stand = true;
		timerToStand.start();
	
	if rider.direccion == Vector2.ZERO:
		velocity = Vector2.ZERO
		if can_stand:
			stand_animation_played = true;
			_set_anim_direction("stand");
			await animated_sprite_2d.animation_finished
			stand_animation_played = false;
		
		if not stand_animation_played:
			_set_anim_direction("idle")
	else:
		rider.global_position = global_position
		rider.velocity = Vector2.ZERO
		direction = rider.direccion
		var is_running = rider.input_correr();
		velocity = rider.direccion * (speed_run if is_running else speed_walk)
		_set_anim_direction("run" if is_running else "walk")

func take_damage(amount: int):
	health -= amount
	if health <= 0:
		_set_anim_direction("death")

func _set_anim_direction(base: String):
	var dir := "down"
	if direction.y < -0.5: dir = "up"
	elif direction.y > 0.5: dir = "down"
	elif direction.x > 0.5: dir = "right"
	elif direction.x < -0.5: dir = "left"
	_play_anim(base + "_" + dir)

func _play_anim(nombre: String):
	if animated_sprite_2d.animation != nombre:
		animated_sprite_2d.play(nombre)
