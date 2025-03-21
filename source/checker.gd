class_name Checker extends Node2D

enum COLOR {
	WHITE,
	BLACK
}
enum ROLES {
	NONE,
	SEDUCER,
	AVENGER,
	HUNTER,
	GLUTTONY,
	MARSHAL,
	TRIXTER
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
		ROLES.AVENGER:
			return "avenger"
		ROLES.HUNTER:
			return "hunter"
		ROLES.GLUTTONY:
			return "gluttony"
		ROLES.MARSHAL:
			return "marshal"
		ROLES.TRIXTER:
			return "trixter"
		_ :
			return "unknown"

func reload_texture() -> void:
	var path: String
	if is_major:
		path = "res://assets/checkers/" + get_color_string(color) + "/major.png"
	else:
		path = "res://assets/checkers/" + get_color_string(color) + "/" + get_role_string(role) + ".png"

	print(path)
	texture = load(path)
	if texture == null:
		print("Ошибка: Текстура шашки не обнаружена в пути ", path)

func _draw() -> void:
	if texture:
		draw_texture(texture, global_position)
