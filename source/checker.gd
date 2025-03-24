class_name Checker extends Sprite2D

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
var self_pose: Array = []

var balance: float = 0
var is_major: bool = false

var outline_actived: bool:
	set(value):
		outline_actived = value
		if material:
			if value == true:
				material.set("shader_parameter/width", 1)
			else:
				material.set("shader_parameter/width", 0)

signal on_clicked(checker: Checker)

func _init(_color: COLOR) -> void:
	self.color = _color

func _ready() -> void:
	material = ShaderMaterial.new()
	material.shader = preload("res://shaders/outline.gdshader")
	material.set("shader_parameter/outline_color", Color.AQUA)
	reload_texture()
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if (event.button_index == MOUSE_BUTTON_LEFT) and event.is_pressed(): 
			if is_pixel_opaque(get_local_mouse_position()):
				print("Мои координаты: " + str(self_pose))
				on_clicked.emit(self)

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
	var path: String = "res://assets/checkers/" + get_color_string(color) + "/" + get_role_string(role) + ".png"
	#print(path)
	texture = load(path)
	if texture == null:
		print("Ошибка: Текстура шашки не обнаружена в пути ", path)
	else:
		self.texture = texture
