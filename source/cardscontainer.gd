class_name PlayerCardsContainer extends Node2D

# Настройки
@export var card_spacing: float = 85.0
@export var card_base_y: float = 75.0
@export var hover_raise_amount: float = -20.0

func _init() -> void:
	connect("child_entered_tree", on_child_entered_tree)

func on_child_entered_tree(child: Node) -> void:
	if child is PlayerCard:
		reposition_cards()
		
		# Настраиваем область наведения для карты
		var area = Area2D.new()
		var collision = CollisionShape2D.new()
		var shape = RectangleShape2D.new()
		
		shape.size = Vector2(80.0, 112.0) * child.scale
		collision.shape = shape
		area.add_child(collision)
		child.add_child(area)
		
		area.mouse_entered.connect(child._on_mouse_entered)
		area.mouse_exited.connect(child._on_mouse_exited)
		area.input_pickable = true

func reposition_cards():
	var cards = get_children().filter(func(c): return c is PlayerCard)
	
	for i in range(cards.size()):
		var card = cards[i]
		var target_x = i * card_spacing
		var target_position = Vector2(target_x, card_base_y)
		
		# Сохраняем базовую позицию для анимации
		card.base_position = target_position
		
		var tween = create_tween()
		tween.set_ease(Tween.EASE_OUT)
		tween.set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(card, "position", target_position, 0.8)
