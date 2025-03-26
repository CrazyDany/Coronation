class_name Cell extends MeshInstance2D

var using_flash: bool:
	set(new_value):
		using_flash = new_value
		if new_value:
			material.set("shader_parameter/color_a", Color.LIGHT_SKY_BLUE)
		else:
			material.set("shader_parameter/color_a", Color.TRANSPARENT)

var board: Board
var position_in_board: Vector2i = Vector2i.ZERO
var is_capture_move: bool = false
var captured_position: Vector2i = Vector2i.ZERO

signal on_clicked(cell)

func _ready() -> void:
	material = material.duplicate()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if (event.button_index == MOUSE_BUTTON_LEFT) and event.is_pressed(): 
			if Rect2(-16, -16, 32, 32).has_point(get_local_mouse_position()):
				on_clicked.emit(self)
