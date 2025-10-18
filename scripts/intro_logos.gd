extends Control

@onready var animation_player = $AnimationPlayer

func _ready():
	# Inicia la animación en cuanto la escena carga
	animation_player.play("SecuenciaLogos")
	# Espera a que la animación termine para pasar a la siguiente escena
	await animation_player.animation_finished
	get_tree().change_scene_to_file("res://scenes/press_to_continue.tscn")
