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

var has_ability: bool

var color: COLOR = COLOR.WHITE
var role: ROLES = ROLES.NONE:
	set(value):
		role = value
		reload_texture()
		
var self_pose: Vector2i = Vector2i.ZERO

var balance: float = 0
var is_major: bool = false:
	set(value):
		is_major = value
		reload_texture()

var outline_actived: bool:
	set(value):
		outline_actived = value
		if material:
			material.set("shader_parameter/width", 1 if value else 0)

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
				on_clicked.emit(self)

func get_color_string(_color: COLOR) -> String:
	return "white" if _color == COLOR.WHITE else "black"

static func get_role_string(new_role: ROLES) -> String:
	match new_role:
		ROLES.SEDUCER: return "seducer"
		ROLES.AVENGER: return "avenger"
		ROLES.HUNTER: return "hunter"
		ROLES.GLUTTONY: return "gluttony"
		ROLES.MARSHAL: return "marshal"
		ROLES.TRIXTER: return "trixter"
		_: return "none"

func reload_texture() -> void:
	var path = "res://assets/checkers/%s/%s.png" % [get_color_string(color), get_role_string(role)]
	if is_major:
		var crown = Sprite2D.new()
		crown.texture = load("res://assets/checkers/crown.png")
		add_child(crown)
		crown.position = Vector2(0, -10)
	texture = load(path)
	if texture == null:
		printerr("Ошибка: Текстура шашки не обнаружена в пути ", path)
