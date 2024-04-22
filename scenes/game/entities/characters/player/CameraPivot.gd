extends Marker2D

@onready var player = owner as Player

# Called when the node enters the scene tree for the first time.
func _ready():
	player.u_turn.connect(_on_player_u_turn)


func _on_player_u_turn(anim_direction):
	match anim_direction:
		"right":
			position.x = 0
		"left":
			position.x = 0
