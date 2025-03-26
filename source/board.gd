class_name Board extends Sprite2D

@export var start_point: Marker2D
@export var cell_size: float
@export var board_width: int = 10
@export var board_height: int = 10
@export var lines_of_checkers: int = 4
@export var turn_label: Label

@export var checkers_cotainer: Node2D
@export var cells_container: Node2D

var cell_scene = preload("res://objects/cell/Cell.tscn")

var cur_turn_color: Checker.COLOR = Checker.COLOR.BLACK
var is_selecting_cell: bool = false
var selected_checker: Checker
var cells: Dictionary[Vector2i, Cell] = {}
var checkers: Dictionary[Vector2i, Checker] = {}

func _ready() -> void:
	initialize_board()
	change_turn()

func initialize_board() -> void:
	for y in range(board_height):
		for x in range(board_width):
			var cell_pos = Vector2i(x, y)
			var new_cell = create_cell(cell_pos)
			cells[cell_pos] = new_cell
			new_cell.board = self

			if should_place_checker(cell_pos, Checker.COLOR.BLACK):
				var black_checker = create_checker(Checker.COLOR.BLACK, new_cell)
				checkers[cell_pos] = black_checker

			if should_place_checker(cell_pos, Checker.COLOR.WHITE):
				var white_checker = create_checker(Checker.COLOR.WHITE, new_cell)
				checkers[cell_pos] = white_checker

func create_cell(pos: Vector2i) -> Cell:
	var new_cell = cell_scene.instantiate()
	if new_cell is Cell:
		new_cell.board = self
		new_cell.allow_to_move_here = false
		new_cell.position_in_board = pos
		new_cell.position = start_point.position + Vector2(pos.x * cell_size, pos.y * cell_size) + Vector2(cell_size/2, cell_size/2)
		new_cell.on_clicked.connect(on_cell_pressed)
	new_cell.name = "Cell %d %d" % [pos.x, pos.y]
	cells_container.add_child(new_cell)
	return new_cell
		
func create_checker(color: Checker.COLOR, cell: Cell) -> Checker:
	var new_checker = Checker.new(color)
	new_checker.outline_actived = false
	new_checker.position = cell.position
	new_checker.self_pose = cell.position_in_board
	new_checker.on_clicked.connect(on_checker_pressed)
	checkers_cotainer.add_child(new_checker)
	return new_checker

func should_place_checker(pos: Vector2i, color: Checker.COLOR) -> bool:
	if (pos.x + pos.y) % 2 == 0:
		if color == Checker.COLOR.BLACK and pos.y < lines_of_checkers:
			return true
		if color == Checker.COLOR.WHITE and pos.y > (board_height - lines_of_checkers - 1):
			return true
	return false

func on_checker_pressed(checker: Checker) -> void:
	if is_selecting_cell and selected_checker == checker:
		reset_cell_selections()
		return
		
	if is_selecting_cell or checker.color != cur_turn_color:
		return

	reset_cell_selections()
	
	is_selecting_cell = true
	selected_checker = checker
	checker.outline_actived = true
	
	var directions = [
		Vector2i(1, 1),
		Vector2i(-1, 1),
		Vector2i(1, -1),
		Vector2i(-1, -1)
	]
	
	for direction in directions:
		var neighbor_pos = checker.self_pose + direction

		if not is_position_valid(neighbor_pos):
			continue
			
		var checker_at_pos = checkers.get(neighbor_pos)
		if checker_at_pos == null:
			cells[neighbor_pos].allow_to_move_here = true
		elif checker_at_pos.color != checker.color:
			var jump_pos = neighbor_pos + direction
			if is_position_valid(jump_pos) and checkers.get(jump_pos) == null:
				cells[jump_pos].allow_to_move_here = true
				cells[jump_pos].is_capture_move = true
				cells[jump_pos].captured_position = neighbor_pos

func on_cell_pressed(cell: Cell) -> void:
	if not is_selecting_cell or not selected_checker or not cell.allow_to_move_here:
		return
	
	checkers.erase(selected_checker.self_pose)

	if cell.is_capture_move:
		var captured_checker = checkers[cell.captured_position]
		if captured_checker:
			checkers_cotainer.remove_child(captured_checker)
			captured_checker.queue_free()
			checkers.erase(cell.captured_position)
	
	selected_checker.position = cell.position
	selected_checker.self_pose = cell.position_in_board
	checkers[cell.position_in_board] = selected_checker
	
	reset_cell_selections()
	change_turn()

func reset_cell_selections() -> void:
	for cell in cells.values():
		cell.allow_to_move_here = false
		cell.is_capture_move = false
		cell.captured_position = Vector2i.ZERO
	
	if selected_checker:
		selected_checker.outline_actived = false
		selected_checker = null
	
	is_selecting_cell = false

func change_turn() -> void:
	cur_turn_color = Checker.COLOR.WHITE if cur_turn_color == Checker.COLOR.BLACK else Checker.COLOR.BLACK
	turn_label.text = "Сейчас ходят: %s" % ["ЧЕРНЫЕ" if cur_turn_color == Checker.COLOR.BLACK else "БЕЛЫЕ"]

func get_checker_by_position(pos: Vector2i) -> Checker:
	return checkers.get(pos, null)

func is_position_valid(pos: Vector2i) -> bool:
	return pos.x >= 0 and pos.x < board_width and pos.y >= 0 and pos.y < board_height
