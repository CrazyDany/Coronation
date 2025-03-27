class_name GameManager extends Node2D

@export var board_width: int = 8
@export var board_height: int = 8
@export var lines_of_checkers: int = 3

@export var visual_manager: VisualManager
@export var turn_manager: TurnManager

var current_turn_color: Checker.COLOR = Checker.COLOR.WHITE
var cells: Dictionary[Vector2i, Cell] = {}
var checkers: Dictionary[Vector2i, Checker] = {}

var player1: Player
@export var player1_cards_container: PlayerCardsContainer
var player2: Player
@export var player2_cards_container: PlayerCardsContainer

var player_card_scene = preload("res://objects/card/PlayerCard.tscn")

enum GameStates {
	HANDOUT,
	BETS,
	TURNS
}

var cur_game_state: GameStates = GameStates.BETS
var in_cutscene: bool = false

var number_generator: RandomNumberGenerator

func _ready():
	number_generator = RandomNumberGenerator.new()
	initialize_board()
	start_new_turn(current_turn_color)

func initialize_board():
	for i in range(6):
		var r_n:int = int(number_generator.randf_range(1.0, 7.0))
		print(r_n)
		add_card(player1, r_n)
	for y in range(board_height):
		for x in range(board_width):
			var pos = Vector2i(x, y)
			create_cell(pos)
			
			if should_place_checker(pos, Checker.COLOR.BLACK):
				create_checker(Checker.COLOR.BLACK, pos)
			elif should_place_checker(pos, Checker.COLOR.WHITE):
				create_checker(Checker.COLOR.WHITE, pos)
	visual_manager.start_cutscene("MAKE YOUR BETS", 1.25)

func create_cell(pos: Vector2i) -> Cell:
	var cell = visual_manager.instantiate_cell_visual(pos)
	cell.connect("on_clicked", turn_manager.on_cell_clicked)
	cells[pos] = cell
	cell.position_in_board = pos
	return cell

func create_checker(color: Checker.COLOR, pos: Vector2i) -> Checker:
	var checker = visual_manager.instantiate_checker_visual(color, pos)
	checker.connect("on_clicked", turn_manager.on_checker_clicked)
	checkers[pos] = checker
	checker.self_pose = pos
	return checker

func should_place_checker(pos: Vector2i, color: Checker.COLOR) -> bool:
	if (pos.x + pos.y) % 2 == 0:
		if color == Checker.COLOR.BLACK and pos.y < lines_of_checkers:
			return true
		if color == Checker.COLOR.WHITE and pos.y >= (board_height - lines_of_checkers):
			return true
	return false

func change_game_state(new_state:GameStates) -> void:
	cur_game_state = new_state
	
func start_new_turn(color: Checker.COLOR) -> void:
	current_turn_color = color
	visual_manager.update_turn_display(color)

func change_turn() -> void:
	current_turn_color = Checker.COLOR.WHITE if current_turn_color == Checker.COLOR.BLACK else Checker.COLOR.BLACK
	start_new_turn(current_turn_color)

func is_position_valid(pos: Vector2i) -> bool:
	return pos.x >= 0 and pos.x < board_width and pos.y >= 0 and pos.y < board_height

func get_checker_at(pos: Vector2i) -> Checker:
	return checkers.get(pos)

func get_cell_at(pos: Vector2i) -> Cell:
	return cells.get(pos)

func move_checker(from_pos: Vector2i, to_pos: Vector2i) -> bool:
	if !is_move_valid(from_pos, to_pos):
		return false

	var checker = checkers.get(from_pos)
	var target_cell = cells.get(to_pos)
	
	if !checker or !target_cell:
		return false
	
	if is_capture_move(from_pos, to_pos):
		var captured_pos = (from_pos + to_pos) / 2
		remove_checker(captured_pos)

	checkers.erase(from_pos)
	checkers[to_pos] = checker
	checker.self_pose = to_pos
	
	visual_manager.move_checker_visual(checker, to_pos)
	
	return true

func is_move_valid(from_pos: Vector2i, to_pos: Vector2i) -> bool:
	if !is_position_valid(from_pos) || !is_position_valid(to_pos):
		return false
	if from_pos == to_pos:
		return false
	return true

func is_capture_move(from_pos: Vector2i, to_pos: Vector2i) -> bool:
	return (from_pos - to_pos).abs() == Vector2i(2, 2)

func remove_checker(pos: Vector2i):
	if checkers.has(pos):
		var checker = checkers[pos]
		checkers.erase(pos)
		visual_manager.remove_checker_visual(checker)
		
func add_card(player_target: Player, role: Checker.ROLES) -> void:
	var new_card = player_card_scene.instantiate()
	new_card.self_role = role
	if player_target == player1:
		player1_cards_container.add_child(new_card)
	else:
		player2_cards_container.add_child(new_card)

class Player:
	var cards: Array[Checker.ROLES] = [Checker.ROLES.SEDUCER, Checker.ROLES.AVENGER, Checker.ROLES.HUNTER, Checker.ROLES.GLUTTONY, Checker.ROLES.MARSHAL, Checker.ROLES.TRIXTER]
	var balance: float = 1000.0
