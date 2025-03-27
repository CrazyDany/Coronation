class_name PlayerCard extends Sprite2D

# Настройки анимации
var hover_scale: Vector2 = Vector2(1.05, 1.05)
var hover_offset: float = -60.0
var hover_duration: float = 0.2

var base_position: Vector2
var base_scale: Vector2 = Vector2.ONE
var is_hovered: bool = false

var self_role: Checker.ROLES:
	set(value):
		self_role = value
		texture = load("res://assets/cards/" + Checker.get_role_string(value) + ".png")

func _ready():
	base_position = Vector2(position.x, position.y+75)
	base_scale = scale
	connect("mouse_entered", _on_mouse_entered)
	connect("mouse_exited", _on_mouse_exited)

func _on_mouse_entered():
	is_hovered = true
	animate_hover(true)

func _on_mouse_exited():
	is_hovered = false
	animate_hover(false)

func animate_hover(hover_state: bool):
	var tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	
	if hover_state:
		tween.parallel().tween_property(self, "scale", hover_scale, hover_duration)
		tween.parallel().tween_property(self, "position:y", base_position.y + hover_offset, hover_duration)
	else:
		tween.parallel().tween_property(self, "scale", base_scale, hover_duration)
		tween.parallel().tween_property(self, "position:y", base_position.y, hover_duration)

	# Поднимаем карту на передний план при наведении
	z_index = 1 if hover_state else 0
