class_name Cell extends Node2D

var allow_to_move_here: bool = false
var board: Board
var position_in_board: Array = [0, 0]
#var font = preload("res://assets/fonts/alagard-12px-unicode.ttf")

signal on_clicked(cell)

func draw_cell() -> void:
	if board:
		var rect = Rect2(-board.cell_size/2, -board.cell_size/2, board.cell_size, board.cell_size)
		draw_rect(rect, Color("#faffff"))

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if (event.button_index == MOUSE_BUTTON_LEFT) and event.is_pressed(): 
			if Rect2(-board.cell_size/2, -board.cell_size/2, board.cell_size, board.cell_size).has_point(get_local_mouse_position()):
				on_clicked.emit(self)
