class_name VisualManager extends Node2D

# Настройки отображения
@export var start_point: Marker2D
@export var cell_size: float = 64.0
@export var turn_label: Label
@export var cells_container: Node2D
@export var checkers_container: Node2D

# Префабы
var cell_scene = preload("res://objects/cell/Cell.tscn")

# Создание визуала клетки
func instantiate_cell_visual(pos: Vector2i) -> Cell:
	var cell = cell_scene.instantiate()
	cell.position = _calculate_world_position(pos)
	if cell is Cell:
		cell.using_flash = false
	cells_container.add_child(cell)
	cell.name = "Cell_%d_%d" % [pos.x, pos.y]
	return cell

# Создание визуала шашки
func instantiate_checker_visual(color: Checker.COLOR, pos: Vector2i) -> Checker:
	var checker = Checker.new(color)
	checker.position = _calculate_world_position(pos)
	checkers_container.add_child(checker)
	return checker

# Обновление UI
func update_turn_display(color: Checker.COLOR):
	turn_label.text = "Ход: %s" % ["Чёрные" if color == Checker.COLOR.BLACK else "Белые"]

# Подсветка клеток
func highlight_cells(positions: Array[Vector2i]):
	for pos in positions:
		var cell = get_cell_at(pos)
		if cell:
			cell.using_flash = true

func reset_all_highlights():
	for cell in cells_container.get_children():
		if cell is Cell:
			cell.using_flash = false

# Вспомогательные методы
func _calculate_world_position(board_pos: Vector2i) -> Vector2:
	return start_point.position + Vector2(
		board_pos.x * cell_size + cell_size/2,
		board_pos.y * cell_size + cell_size/2
	)

func get_cell_at(pos: Vector2i) -> Cell:
	for cell in cells_container.get_children():
		if cell.position_in_board == pos:
			return cell
	return null

func calculate_cell_position(board_pos: Vector2i) -> Vector2:
	return start_point.position + Vector2(
		board_pos.x * cell_size + cell_size/2,
		board_pos.y * cell_size + cell_size/2
	)

func move_checker_visual(checker: Checker, new_pos: Vector2i):
	var target_position = calculate_cell_position(new_pos)
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(checker, "position", target_position, 0.3)
	tween.parallel().tween_property(checker, "scale", Vector2(1.1, 1.1), 0.15).set_delay(0)
	tween.parallel().tween_property(checker, "scale", Vector2(1, 1), 0.3).set_delay(0.15)

func remove_checker_visual(checker: Checker):
	checker.queue_free()
