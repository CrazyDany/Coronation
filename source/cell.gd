class_name Cell extends Node2D

var allow_to_move_here: bool = false
var board: Board
var position_in_board: Array = [0, 0]
	
func _draw() -> void:
	if board:
		var rect = Rect2(position_in_board[0]*board.cell_size, position_in_board[1]*board.cell_size, board.cell_size, board.cell_size)
		if allow_to_move_here:
			draw_rect(rect, Color("#faffff"))
		else:	
			draw_rect(rect, Color("#928fb8"))
