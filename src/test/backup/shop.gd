extends Control


@onready var marker_2d: Marker2D = $Marker2D


# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 商店相关变量初始化 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
@export var from: Control
@export var card_scene: PackedScene
var card_offset_x: float = 53.0
var rot_max: float = deg_to_rad(10.0)
var anim_offset_y: float = 3.0
var time_multiplier: float = 3.0
var tween: Tween
var tween_animate: Tween
var time: float = 0.0
var sine_offset_mult: float = 0.0
var drawn: bool = false

var cards: Array


var purchased_cards: Array
var equipment_cards: Array

var refreshing: bool = false


func _ready():
	set_process(false)
	#await get_tree().create_timer(2.0).timeout
	#draw_cards(from.global_position, 10)

func _physics_process(delta: float) -> void:
	update_mouse_filters()
	for card in cards:
		if card.purchased:
			cards.erase(card)
			purchased_cards.append(card)
	#time += delta
	#for card in cards:
		#var i := cards.find(card)
		#var val: float = sin(i + (time * time_multiplier))
		##print("Child %d, sin(%d) = %f" % [i, i, val])
		#card.position.y = cards_pos[i].y + val * sine_offset_mult
	

func update_mouse_filters():
	var is_any_card_following_mouse = false
	var moving_card = null

	# 检查是否有卡片正在跟随鼠标
	for card in cards:
		if card.following_mouse:
			is_any_card_following_mouse = true
			moving_card = card
			break  # 找到后立即退出循环

	# 根据是否有卡片正在跟随鼠标来设置其他卡片的 mouse_filter
	if is_any_card_following_mouse:
		for card in cards:
			if card != moving_card:
				if card.mouse_filter != MOUSE_FILTER_IGNORE:
					card.mouse_filter = MOUSE_FILTER_IGNORE
			else:
				if card.mouse_filter != MOUSE_FILTER_STOP:
					card.mouse_filter = MOUSE_FILTER_STOP
	else:
		for card in cards:
			if card.mouse_filter != MOUSE_FILTER_STOP:
				card.mouse_filter = MOUSE_FILTER_STOP
	
func refresh_cards(from_pos: Vector2, number: int) -> void:
	if refreshing:
		return
	refreshing = true
	if cards.size() > 0:
		if tween and tween.is_running():
			tween.kill()
		tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(self, "sine_offset_mult", 0.0, 1.0)
	
		for card in cards:
			card.destroy()
		
		await tween.finished
		
	cards.clear()
	tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
			
	for i in range(number):
		var instance: Button = card_scene.instantiate()
		add_child(instance)
		instance.global_position = from_pos
		
		var final_pos: Vector2 = -(instance.size / 2.0) - Vector2(card_offset_x * (number - 1 - i), 0.0) + marker_2d.position
		var rot_radians: float = lerp_angle(-rot_max, rot_max, float(i)/float(number-1))
		# Animate pos
		tween.parallel().tween_property(instance, "position", final_pos, 0.3 + (i * 0.075))
		tween.parallel().tween_property(instance, "rotation", rot_radians, 0.3 + (i * 0.075))
		
		cards.append(instance)
	
	tween.tween_callback(set_process.bind(true))
	# tween.tween_property(self, "sine_offset_mult", anim_offset_y, 1.5).from(0.0)
	
	await tween.finished
	refreshing = false
	

func _on_refresh_button_pressed() -> void:
	refresh_cards(from.global_position, 5)
