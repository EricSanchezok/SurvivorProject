extends Control

@onready var refresh_button: Button = $ShopAndInventory/Up/MarginContainer/RefreshButton
@onready var shop_marker_2d: Marker2D = $ShopAndInventory/Up/ShopMarker2D
@onready var shop_cards_container: MarginContainer = $ShopAndInventory/Up/ShopCardsContainer
@onready var inventory_cards_container: MarginContainer = $ShopAndInventory/Down/InventoryCardsContainer
@onready var state_machine: StateMachine = $StateMachine


var number_of_cards_drawn: int = 5
var number_of_cards_inventory: int = 10

var rot_max: float = deg_to_rad(10.0)

var card_scene = preload("res://src/main/common/classes/ui/weapon_card.tscn")

var tween_appear: Tween
var tween_disappear: Tween
var tween_refresh: Tween
var tween_purchase: Tween

var equip_a: float = 210.0
var equip_b: float = 75.0


var start_draw: bool = false # 按下抽卡按钮开始抽卡

var in_shop_cards: Array[WeaponCard]
var in_inventory_cards: Array
var in_equipment_cards: Array
var equipment_positions: Array[Vector2]
var equipment_areas

var start_show: bool = false
var start_hide: bool = false


func _ready() -> void:
	# 初始状态为隐藏
	hide()
	# 初始化库存和装备的槽位，全为null
	in_inventory_cards.resize(10)
	in_inventory_cards.fill(null)
	in_equipment_cards.resize(10)
	in_equipment_cards.fill(null)
	# 获取装备槽位的节点，方便做弹出动画
	equipment_areas = $Equipment.get_children()
	equipment_positions.resize(10)
	caculate_equipment_positions()
	
	


func show_screen() -> void:
	start_show = true
	state_machine.set_physics_process(true)
	
func hide_screen() -> void:
	start_hide = true
	
	
func get_shop_card_position(index: int, card_size: Vector2) -> Vector2:
	var x_offset = shop_cards_container.size.x / number_of_cards_drawn
	var marker_position = shop_cards_container.position + Vector2(x_offset/2, 29 + 10)
	var target_position = -(card_size / 2.0) + Vector2(x_offset * (number_of_cards_drawn - 1 - index), 0.0) + marker_position
	
	return target_position
	
func get_inventory_card_position(card_size: Vector2) -> Array:
	var index: int = -1
	for i in in_inventory_cards.size():
		if in_inventory_cards[i] == null:
			index = i
			break
	if index != -1:
		var target_position = get_inventory_position_from_index(index, card_size)
		return [target_position, index]
	return [Vector2.ZERO, index]
	
func get_inventory_position_from_index(index: int, card_size: Vector2) -> Vector2:
	var x_offset = (inventory_cards_container.size - Vector2(100, 30)).x / number_of_cards_inventory
	var marker_position = Vector2(50, 15) + $ShopAndInventory/Down.position + Vector2(x_offset/2, 29)
	var target_position = -(card_size / 2.0) + Vector2(x_offset * index, 0.0) + marker_position	
	return target_position

func cleaned_up(array: Array) -> bool:
	if array.size() == 0:
		return true
	for element in array:
		if is_instance_valid(element):
			return false
	array.clear()
	return true

enum State{
	INIT,
	APPERA,
	DISAPPEAR,
	CLEAN,
	DRAW,
}

func tick_physics(state: State, delta: float) -> void:
	update_mouse_filters()
	match state:
		State.INIT:
			pass
		State.APPERA:
			pass
		State.DISAPPEAR:
			pass
		State.CLEAN:
			pass
		State.DRAW:
			pass


func get_next_state(state: State) -> int:
	if start_hide:
		start_hide = false
		return StateMachine.KEEP_CURRENT if state != State.DISAPPEAR else State.DISAPPEAR
		
	match state:
		State.INIT:
			if start_show:
				start_show = false
				return State.APPERA
		State.APPERA:
			if not $AnimationPlayer.is_playing():
				return State.CLEAN
		State.DISAPPEAR:
			if not $AnimationPlayer.is_playing():
				return State.INIT
		State.CLEAN:
			if cleaned_up(in_shop_cards) and visible:
				return State.DRAW
		State.DRAW:
			if start_draw:
				start_draw = false
				return State.CLEAN

	return StateMachine.KEEP_CURRENT
	
func transition_state(from: State, to: State) -> void:	
	print("[%s] %s => %s" % [Engine.get_physics_frames(),State.keys()[from] if from != -1 else "<START>",State.keys()[to],]) 
	match to:
		State.INIT:
			# 在默认情况下将本节点的状态机关闭以节省资源
			state_machine.set_physics_process(false)
		State.APPERA:
			$AnimationPlayer.play("appear")
			tween_appear = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
			for i in range(equipment_areas.size()):
				tween_appear.parallel().tween_property(equipment_areas[i], "position", equipment_positions[i]-equipment_areas[i].size/2, 0.5)
		State.DISAPPEAR:
			$AnimationPlayer.play("disappear")
		State.CLEAN:
			if in_shop_cards.size() > 0:
				if tween_refresh and tween_refresh.is_running():
					tween_refresh.kill()
				tween_refresh = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
				tween_refresh.tween_property(self, "sine_offset_mult", 0.0, 1.0)
			
				for card in in_shop_cards:
					card.destroy()
				
		State.DRAW:
			tween_refresh = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
			for i in range(number_of_cards_drawn):
				var instance: Button = card_scene.instantiate()
				instance.global_position = refresh_button.global_position
				add_child(instance)
				
				instance.connect("apply_to_purchase",_on_apply_to_purchase)
				instance.connect("apply_to_exchange", _on_apply_to_exchange)
				instance.connect("apply_to_destroy", _on_apply_to_destroy)
				
				var final_pos = get_shop_card_position(i, instance.size)
				var rot_radians: float = lerp_angle(rot_max, -rot_max, float(i)/float(number_of_cards_drawn-1))
	
				var speed: float = 900.0
				var distance: float = final_pos.distance_to(instance.global_position)
				var time: float = distance / speed
				
				tween_refresh.parallel().tween_property(instance, "position", final_pos, time)
				tween_refresh.parallel().tween_property(instance, "rotation", rot_radians, time)
				
				in_shop_cards.append(instance)
				

func _on_apply_to_purchase(card: WeaponCard) -> void:
	var result = get_inventory_card_position(card.size)
	var target_position = result[0]
	var target_index = result[1]
	if target_position == Vector2.ZERO:
		return
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.parallel().tween_property(card, "position", target_position, 0.3)
	tween.parallel().tween_property(card, "rotation", 0.0, 0.3)
	
	
	in_shop_cards.erase(card) # 在商店卡牌中清除掉该卡牌
	in_inventory_cards[target_index] = card # 在库存卡牌中添加该卡牌
	
	await tween.finished
	card.purchased = true # 使得该卡牌进入 inventory 状态
	
func _on_apply_to_exchange(card: WeaponCard, now_position: Vector2) -> void:
	var card_state = card.state_machine.current_state
	if card_state == card.State.INVENTORY:
		var min_distance = INF
		var min_distance_index = -1
		for index in range(in_inventory_cards.size()):
			var distance_squared = now_position.distance_squared_to(get_inventory_position_from_index(index, card.size))
			if distance_squared <= min_distance: 
				min_distance = distance_squared
				min_distance_index = index
		print("最小距离： ", min_distance, ", index: ", min_distance_index)
		if min_distance < 1500:
			var current_index = in_inventory_cards.find(card)
			var current_index_position = get_inventory_position_from_index(current_index, card.size)
			var target_position = get_inventory_position_from_index(min_distance_index, card.size)
			if in_inventory_cards[min_distance_index] != null: # 该位置存在卡牌
				print("该位置有卡牌哦~")
				var target_card = in_inventory_cards[min_distance_index]
				in_inventory_cards[current_index] = target_card
				in_inventory_cards[min_distance_index] = card
				
				card.start_exchange = true
				target_card.start_exchange = true
				var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
				tween.parallel().tween_property(card, "position", target_position, 0.3)
				tween.parallel().tween_property(target_card, "position", current_index_position, 0.3)
				
				await tween.finished
				card.to_inventory = true
				target_card.to_inventory = true
				
			else:
				print("该位置没有卡牌，可以移动过去~")
				in_inventory_cards[current_index] = null
				in_inventory_cards[min_distance_index] = card
				
				card.start_exchange = true
				var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
				tween.tween_property(card, "position", target_position, 0.3)
				
				await tween.finished
				card.to_inventory = true
				
		else:
			card.back()
	elif card_state == card.State.EQUIPMENT:
		pass
	
func _on_apply_to_destroy(card: WeaponCard) -> void:
	var card_state = card.state_machine.current_state
	if card_state == card.State.INVENTORY:
		var index = in_inventory_cards.find(card)
		in_inventory_cards[index] = null
	elif card_state == card.State.EQUIPMENT:
		var index = in_equipment_cards.find(card)
		in_equipment_cards[index] = null
	
	card.destroy()
		
func update_mouse_filters():
	var is_any_card_following_mouse = false
	var moving_card = null

	# 检查是否有卡片正在跟随鼠标
	for card in in_inventory_cards:
		if card == null:
			continue
		if card.following_mouse:
			is_any_card_following_mouse = true
			moving_card = card
			break  # 找到后立即退出循环

	# 根据是否有卡片正在跟随鼠标来设置其他卡片的 mouse_filter
	if is_any_card_following_mouse:
		for card in in_inventory_cards:
			if card == null:
				continue
			if card != moving_card:
				if card.mouse_filter != MOUSE_FILTER_IGNORE:
					card.mouse_filter = MOUSE_FILTER_IGNORE
			else:
				if card.mouse_filter != MOUSE_FILTER_STOP:
					card.mouse_filter = MOUSE_FILTER_STOP
	else:
		for card in in_inventory_cards:
			if card == null:
				continue
			if card.mouse_filter != MOUSE_FILTER_STOP:
				card.mouse_filter = MOUSE_FILTER_STOP
				
# 计算椭圆上的y坐标
func calculate_y_on_ellipse(x, a, b):
	var y_squared = b * b * (1 - (x * x) / (a * a))
	if y_squared < 0:
		return "No real solution"  # 在数学上不可能，除非有计算误差或数据错误
	return sqrt(y_squared)

func caculate_equipment_positions() -> void:
	var viewport_size = get_viewport_rect().size
	var x = equip_a/3
	var y = calculate_y_on_ellipse(x, equip_a, equip_b)
	equipment_positions[0] = Vector2(-x, -y)
	equipment_positions[4] = Vector2(-x, y)
	equipment_positions[5] = Vector2(x, -y)
	equipment_positions[9] = Vector2(x, y)
	x = 2*equip_a/3
	y = calculate_y_on_ellipse(x, equip_a, equip_b)
	equipment_positions[1] = Vector2(-x, -y)
	equipment_positions[3] = Vector2(-x, y)
	equipment_positions[6] = Vector2(x, -y)
	equipment_positions[8] = Vector2(x, y)
	x = equip_a
	y = calculate_y_on_ellipse(x, equip_a, equip_b)
	equipment_positions[2] = Vector2(-x, -y)
	equipment_positions[7] = Vector2(x, y)
	for i in range(equipment_positions.size()):
		equipment_positions[i] += viewport_size / 2

func _on_refresh_button_pressed() -> void:
	start_draw = true


#func _on_timer_timeout() -> void:
	#first_enter = false

	#visibility_changed.connect(func ():
		#get_tree().paused = visible	
	#)
	
#func _input(event: InputEvent) -> void:
	#if event.is_action_pressed("shop"):
		#hide()
		#state_machine.set_process(false)
		#get_window().set_input_as_handled()
		#owner.recover_from_shop_screen()
