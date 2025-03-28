class_name TurnManager extends Node2D

@export var game_manager: GameManager
var selected_checker: Checker
var is_selecting: bool = false

var black_crown_checker: Checker
var white_crown_checker: Checker

func start_turn(color: Checker.COLOR):
	reset_selection()

func on_checker_clicked(checker: Checker):
	if not game_manager.in_cutscene:
		if game_manager.cur_game_state == GameManager.GameStates.TURNS: #Или просто 2
			print("Шашка нажата и ее координаты - " + str(checker.self_pose))
			if is_selecting and selected_checker == checker:
				reset_selection()
				return
				
			if checker.color != game_manager.current_turn_color:
				return
				
			if selected_checker:
				selected_checker.outline_actived = false
			selected_checker = checker
			is_selecting = true
			highlight_available_moves(checker)
			checker.outline_actived = true
			
		elif game_manager.cur_game_state == GameManager.GameStates.BETS:
			if checker.color == Checker.COLOR.BLACK:
				if black_crown_checker:
					print("Черная королевская пешка уже выбрана!")
				else:
					black_crown_checker = checker
					checker.is_major = true
			else:
				if white_crown_checker:
					print("Белая королевская пешка уже выбрана!")
				else:
					white_crown_checker = checker
					checker.is_major = true
			
			if (white_crown_checker and black_crown_checker):
				game_manager.visual_manager.start_cutscene("FIRST TURN!", 1.25)
				game_manager.change_game_state(GameManager.GameStates.TURNS)

func on_cell_clicked(cell: Cell):
	if not is_selecting or not selected_checker:
		return
		
	if not cell.using_flash:
		return
		
	# Перемещение шашки
	game_manager.move_checker(selected_checker.self_pose, cell.position_in_board)
	reset_selection()
	game_manager.change_turn()

func highlight_available_moves(checker: Checker):
	game_manager.visual_manager.reset_all_highlights()
	
	var directions = [Vector2i(1,1), Vector2i(-1,1), Vector2i(1,-1), Vector2i(-1,-1)]
	for dir in directions:
		var neighbor_pos = checker.self_pose + dir
		if not game_manager.is_position_valid(neighbor_pos):
			continue
			
		var checker_at_pos = game_manager.get_checker_at(neighbor_pos)
		if checker_at_pos == null:
			game_manager.visual_manager.highlight_cells([neighbor_pos])
		elif checker_at_pos.color != checker.color:
			var jump_pos = neighbor_pos + dir
			if game_manager.is_position_valid(jump_pos) and game_manager.get_checker_at(jump_pos) == null:
				game_manager.visual_manager.highlight_cells([jump_pos])

func reset_selection():
	game_manager.visual_manager.reset_all_highlights()
	selected_checker.outline_actived = false
	selected_checker = null
	is_selecting = false
