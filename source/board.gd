class_name Board extends Sprite2D

@export var start_point: Marker2D
@export var cell_size: float
@export var board_width: int = 10
@export var board_height: int = 10

@export var cell_container: Node2D 
func _ready() -> void:
	if cell_container:
		for n in range(board_height):
			for k in range(board_width):
				var new_cell = Cell.new()
				new_cell.position.x = k*cell_size
				new_cell.position.y = n*cell_size
				new_cell.position_in_board = [k, n]
				new_cell.board = self
				cell_container.add_child(new_cell)
				print(new_cell)
