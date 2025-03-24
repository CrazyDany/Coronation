class_name Board extends Sprite2D

@export var start_point: Marker2D
@export var cell_size: float
@export var board_width: int = 10
@export var board_height: int = 10
@export var lines_of_checkers: int = 4
@export var turn_label: Label

var cur_turn_color: Checker.COLOR = Checker.COLOR.BLACK
var is_selecting_cell: bool = false
var selected_checker: Checker
var cells: Dictionary = {}
var checkers: Dictionary = {}

func _ready() -> void:
	initialize_board()
	change_turn()

func initialize_board() -> void:
	for n in range(board_height):
		for k in range(board_width):
			var new_cell = create_cell(k, n)
			cells[[n, k]] = new_cell  # Сохраняем ячейку в словаре
			new_cell.board = self

			if should_place_checker(n, k, Checker.COLOR.BLACK):
				var black_checker = create_checker(Checker.COLOR.BLACK, new_cell)
				checkers[[n, k]] = black_checker  # Сохраняем шашку в словаре

			if should_place_checker(n, k, Checker.COLOR.WHITE):
				var white_checker = create_checker(Checker.COLOR.WHITE, new_cell)
				checkers[[n, k]] = white_checker  # Сохраняем шашку в словаре

func create_cell(k: int, n: int) -> Cell:
	var new_cell = Cell.new()
	new_cell.position_in_board = [k, n]
	new_cell.name = "Cell " + str(k) + " " + str(n)
	new_cell.position = start_point.position + Vector2(k * cell_size, n * cell_size)
	new_cell.on_clicked.connect(on_cell_pressed)
	add_child(new_cell)
	return new_cell

func create_checker(color: Checker.COLOR, cell: Cell) -> Checker:
	var new_checker = Checker.new(color)
	new_checker.outline_actived = false
	new_checker.position = cell.position + Vector2(cell_size / 2, cell_size / 2)  # Центрируем шашку
	new_checker.self_pose = [cell.position_in_board[0], cell.position_in_board[1]]
	new_checker.on_clicked.connect(on_checker_pressed)
	add_child(new_checker)
	return new_checker

func should_place_checker(n: int, k: int, color: Checker.COLOR) -> bool:
	if (n + k) % 2 == 0:
		if color == Checker.COLOR.BLACK and n < lines_of_checkers:
			return true
		if color == Checker.COLOR.WHITE and n > (board_height - lines_of_checkers - 1):
			return true
	return false

func on_checker_pressed(checker: Checker) -> void:
	if checker.color == cur_turn_color and not is_selecting_cell:
		is_selecting_cell = true
		selected_checker = checker
		checker.outline_actived = true

func on_cell_pressed(cell: Cell) -> void:
	if is_selecting_cell and selected_checker:
		var target_position = cell.position_in_board

func change_turn() -> void:
	cur_turn_color = Checker.COLOR.WHITE if cur_turn_color == Checker.COLOR.BLACK else Checker.COLOR.BLACK
	turn_label.text = "Сейчас ходят: " + ("ЧЕРНЫЕ "if cur_turn_color == Checker.COLOR.BLACK else "БЕЛЫЕ")

func get_checker_by_position(position: Array) -> Checker:
	return checkers.get(position, null)
