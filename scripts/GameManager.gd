extends Node

# Variables globales
var game_state = "Playing" # 'Playing', 'Paused', 'Game_Over'
var moral = 100
var alive_members = ["Padre", "Hijo", "Madre", "Hija", "Abuela"];
var current_level_params = {} # Parámetros específicos del nivel
var current_level = 1 # Número del nivel actual
var inventory: Array[Objetos] = [] # Objetos en el inventario
enum Objetos {Hamaca, Balas, Cuerda, Escopeta, Fosforos, Documentos, Linterna, Cuchillo, Machete, Hayacas}
func _ready():
    # Inicialización o configuraciones iniciales
    print("GameManager cargado y listo para ser usado globalmente.")

func dead_members():
    alive_members.pop_back()
    if (alive_members.size() == 0):
        game_state = "Game_Over"
        print("Juego terminado.")

# Función para cambiar el estado
func change_state(new_state):
    game_state = new_state
    print("Nuevo estado del juego: " + game_state)

# Función para actualizar la moral
func add_moral(amount):
    moral = clampi(moral + amount, 0, 100) # clampi limita el valor entre 0 y 100
    print("Moral actual: " + str(moral))