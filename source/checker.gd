class_name Checker extends Node2D

enum COLOR {
	WHITE,
	BLACK
}
enum ROLES {
	NONE,
	SEDUCER,
	VENGSPIT,
	POACHER,
	GLUTTONY,
	STRATEG,
	JESTER
}

var color: COLOR = COLOR.WHITE
var role: ROLES = ROLES.NONE

var texture: Texture2D

var balance: float = 0
var is_major: bool = false

func _ready() -> void:
	reload_texture()

func get_color_string(color: COLOR) -> String:
	match color:
		COLOR.WHITE: 
			return "white"
		COLOR.BLACK: 
			return "black"
		_: 
			return "unknown"

func get_role_string(role: ROLES) -> String:
	match role:
		ROLES.NONE: 
			return "none"
		ROLES.SEDUCER:
			return "seducer"
		ROLES.VENGSPIT:
			return "vengspit"
		ROLES.POACHER:
			return "poacher"
		ROLES.GLUTTONY:
			return "gluttony"
		ROLES.STRATEG:
			return "strateg"
		ROLES.JESTER:
			return "jester"
		_ :
			return "unknown"

func reload_texture() -> void:
	var path: String
	if is_major:
		path = "res://assets/chekers/" + get_color_string(color) + "/major.png"
	else:
		path = "res://assets/chekers/" + get_color_string(color) + "/" + get_role_string(role) + ".png"

	print(path)
	texture = load(path)
	if texture == null:
		print("Ошибка: Текстура шашки не обнаружена в пути ", path)

func _draw() -> void:
	if texture:
		draw_texture(texture, global_position)
