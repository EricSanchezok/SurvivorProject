extends Node

var weapon_data_base: Array = [] # 武器基础数据库

class WeaponPoolItem:
	var id: int = 0
	var weapon_name = ""
	var resource_path = ""
	var icon_path = ""
	var level: int = 1
	var price: int = 10
	var star_rating: int = 1
	var current_quantity: int = 0
	var max_quantity: int = -1
	var weapon_class: String
	var weapon_origin: String
	
	func clone():
		var new_item = WeaponPoolItem.new()
		new_item.id = id
		new_item.weapon_name = weapon_name
		new_item.resource_path = resource_path
		new_item.icon_path = icon_path
		new_item.level = level
		new_item.price = price
		new_item.star_rating = star_rating
		new_item.current_quantity = current_quantity
		new_item.max_quantity = max_quantity
		new_item.weapon_class = weapon_class
		new_item.weapon_origin = weapon_origin
		return new_item

	func equals(other: WeaponPoolItem) -> bool:
		return id == other.id and level == other.level

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 关卡初始化变量 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
var activated_level: Node2D # 当前激活的关卡
var activated_players: Array # 当前激活的玩家
var activated_station_areas: PositionGenerator # 固定武器生成区域
var weapon_pool = [] # 武器池
var players_weapons = {} # 玩家武器字典

signal init_finish # 初始化完成

func _ready():
	# 加载武器基础数据
	load_weapon_data_base("res://src/main/WeaponDataBase.xlsx")
	

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 功能函数 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
func upgrade_weapon(player: PlayerBase, slot_index: int, level: int) -> void:
	'''
	升级武器

	:param player: 玩家
	:param slot_index: 武器槽索引
	:param level: 升级等级
	:return: None
	'''
	
	# print("升级武器")
	for weapon in players_weapons[player]:
		# print("weapon_slot_index: ", weapon.slot_index, "    ", slot_index)
		if weapon.slot_index == slot_index:
			weapon.weapon_level = level
			break

func level_initialization(level: Node2D, players: Array, station_areas: PositionGenerator) -> void:
	'''
	关卡初始化

	:param level: 当前激活的关卡
	'''
	print("关卡初始化")
	activated_level = level
	activated_players = players
	activated_station_areas = station_areas

	# 初始化武器池
	weapon_pool.clear()
	create_weapon_pool()

	# 初始化玩家武器字典
	players_weapons.clear()
	for player in players:
		print("玩家初始化: ", player)
		player.connect("register_weapon", _on_player_register_weapon)
		player.connect("unregister_weapon", _on_player_unregister_weapon)
		players_weapons[player] = []
	init_finish.emit()

func draw_weapon(player_level: int) -> WeaponPoolItem:
	'''
	抽取武器

	:param player_level: 玩家等级
	:return: 抽取的武器
	'''

	# print("抽取武器")

	# 根据玩家等级确定星级概率
	var star_probs = {}
	if player_level == 1 or player_level == 2:
		star_probs = {1: 1.0}
	elif player_level == 3:
		star_probs = {1: 0.75, 2: 0.25}
	elif player_level == 4:
		star_probs = {1: 0.55, 2: 0.30, 3: 0.15}
	elif player_level == 5:
		star_probs = {1: 0.45, 2: 0.33, 3: 0.20, 4: 0.02}
	elif player_level == 6:
		star_probs = {1: 0.30, 2: 0.40, 3: 0.25, 4: 0.05}
	elif player_level == 7:
		star_probs = {1: 0.19, 2: 0.30, 3: 0.40, 4: 0.10, 5: 0.01}
	elif player_level == 8:
		star_probs = {1: 0.18, 2: 0.25, 3: 0.32, 4: 0.22, 5: 0.03}
	elif player_level == 9:
		star_probs = {1: 0.10, 2: 0.20, 3: 0.25, 4: 0.35, 5: 0.10}
	elif player_level == 10:
		star_probs = {1: 0.05, 2: 0.10, 3: 0.20, 4: 0.40, 5: 0.25}
	elif player_level >= 11:
		star_probs = {1: 0.01, 2: 0.02, 3: 0.12, 4: 0.50, 5: 0.35}

	# 过滤可抽取的武器
	var available_weapons = []
	for item in weapon_pool:
		if item.current_quantity > 0 and star_probs.has(item.star_rating):
			available_weapons.append(item)

	# 如果没有可抽取的武器，返回null
	if available_weapons.size() == 0:
		return null

	# 根据星级概率抽取武器
	var total_prob = 0.0
	var cumulative_probs = []
	for item in available_weapons:
		var prob = star_probs[item.star_rating]
		total_prob += prob
		cumulative_probs.append(total_prob)

	var rand = randf() * total_prob
	for i in range(cumulative_probs.size()):
		if rand < cumulative_probs[i]:
			var chosen_weapon = available_weapons[i]
			chosen_weapon.current_quantity -= 1 # 减少当前数量
			print_weapon_pool_counter()
			return chosen_weapon

	

	return null

func recycle_weapon(weapon_pool_item: WeaponPoolItem, number: int) -> void:
	'''
	回收武器

	:param weapon_pool_item: 需要回收的武器
	:param number: 回收数量
	:return: None
	'''

	# print("回收武器")

	for item in weapon_pool:
		if item.id == weapon_pool_item.id:
			item.current_quantity += number
			break

	print_weapon_pool_counter()


func create_weapon_pool() -> void:
	'''
	创建武器池
	'''
	for weapon_data in weapon_data_base:
		var weapon_pool_item = WeaponPoolItem.new()
		weapon_pool_item.id = weapon_data["id"]
		weapon_pool_item.weapon_name = weapon_data["weapon_name"]
		weapon_pool_item.resource_path = weapon_data["resource_path"]
		weapon_pool_item.icon_path = weapon_data["icon_path"]
		weapon_pool_item.price = weapon_data["price"]

		var details = allocate_weapon_details(weapon_pool_item.price)
		weapon_pool_item.star_rating = details["star_rating"]

		
		weapon_pool_item.max_quantity = details["quantity"] if weapon_data["max_quantity"] == -1 else weapon_data["max_quantity"]
		weapon_pool_item.current_quantity = weapon_pool_item.max_quantity

		weapon_pool_item.weapon_class = weapon_data["weapon_class"]
		weapon_pool_item.weapon_origin = weapon_data["weapon_origin"]

		weapon_pool.append(weapon_pool_item)


func load_weapon_data_base(path: String) -> void:
	'''
	加载武器基础数据

	:param path: 武器基础数据表路径
	:return: None
	'''

	var excel = ExcelFile.open_file(path)
	var workbook = excel.get_workbook()

	var sheet = workbook.get_sheet(0)
	var table_data = sheet.get_table_data()
	for i in range(table_data.size()-1):
		var row_index = i + 2
		var data = {}
		for j in range(table_data[1].size()):
			data[table_data[1][j+1]] = table_data[row_index][j+1]
		weapon_data_base.append(data)
		
		
func allocate_weapon_details(price: float) -> Dictionary:
	'''
	根据传入的价格，返回对应卡池中的数量和星级

	:param price: 武器价格
	:return: 包含武器数量和星级的字典
	'''
	var details = {
		"quantity": -1,
		"star_rating": 1
	}

	if price >= 0 and price < 50:
		details["quantity"] = 22
		details["star_rating"] = 1
	elif price >= 50 and price < 100:
		details["quantity"] = 20
		details["star_rating"] = 2
	elif price >= 100 and price < 150:
		details["quantity"] = 17
		details["star_rating"] = 3
	elif price >= 150 and price < 200:
		details["quantity"] = 10
		details["star_rating"] = 4
	elif price >= 200 and price < 250:
		details["quantity"] = 9
		details["star_rating"] = 5

	return details

func print_weapon_pool_item(weapon_pool_item: WeaponPoolItem) -> void:
	'''
	打印武器池中的武器信息

	:param weapon_pool_item: 武器池中的武器
	:return: None
	'''
	print("id:", weapon_pool_item.id)
	print("weapon_name:", weapon_pool_item.weapon_name)
	print("resource_path:", weapon_pool_item.resource_path)
	print("icon_path:", weapon_pool_item.icon_path)
	print("level:", weapon_pool_item.level)
	print("price:", weapon_pool_item.price)
	print("star_rating:", weapon_pool_item.star_rating)
	print("current_quantity:", weapon_pool_item.current_quantity)
	print("max_quantity:", weapon_pool_item.max_quantity)
	print("weapon_class:", weapon_pool_item.weapon_class)
	print("weapon_origin:", weapon_pool_item.weapon_origin)

func print_weapon_pool() -> void:
	'''
	打印武器池中的所有武器信息

	:return: None
	'''
	print(">>>>>>>>>>>>>>>>>>>武器池信息>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>")
	for weapon_pool_item in weapon_pool:
		print(">>>>>>>>>>>>>>>>>")
		print_weapon_pool_item(weapon_pool_item)

func print_weapon_pool_counter() -> void:
	'''
	打印武器池中的武器数量

	:return: None
	'''
	print(">>>>>>>>>>>>>>>>>>>武器池数量>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>")
	for weapon_pool_item in weapon_pool:
		print(weapon_pool_item.weapon_name, "    数量：", weapon_pool_item.current_quantity)

func find_most_similar_tscn(filenames, folder_name):
	'''
	查找最相似的tscn文件

	:param filenames: 文件名列表
	:param folder_name: 文件夹名
	:return: 最相似的文件名
	'''
	var best_match = ""
	var lowest_distance = INF  # 初始设置为无限大
	var normalized_folder_name = folder_name.replace("'", "").replace(" ", "_").to_lower()
	for filename in filenames:
		if filename.ends_with(".tscn"):
			var normalized_filename = filename.replace("'", "").replace(" ", "_").to_lower()
			var distance = levenshtein(normalized_folder_name, normalized_filename)
			if distance < lowest_distance:
				lowest_distance = distance
				best_match = filename
	#print("文件夹名： ", folder_name, " 匹配的文件名：", best_match)
	return best_match
	

func levenshtein(a: String, b: String) -> int:
	'''
	计算两个字符串之间的编辑距离

	:param a: 字符串a
	:param b: 字符串b
	:return: 编辑距离
	'''
	var costs = []
	for i in range(a.length() + 1):
		costs.append([])
		for j in range(b.length() + 1):
			if i == 0:
				costs[i].append(j)
			elif j == 0:
				costs[i].append(i)
			else:
				costs[i].append(0)
	for i in range(1, a.length() + 1):
		for j in range(1, b.length() + 1):
			var cost = 0 if a[i - 1] == b[j - 1] else 1
			costs[i][j] = min(costs[i - 1][j] + 1, costs[i][j - 1] + 1, costs[i - 1][j - 1] + cost)
	return costs[a.length()][b.length()]


# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 回调函数 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

func _on_player_register_weapon(player: CharacterBody2D, weapon_pool_item: WeaponPoolItem, slot_index: int) -> void:
	'''
	注册武器
	
	:param player: 玩家
	:param weapon_name: 武器名
	:param slot_index: 武器槽索引
	:return: None
	'''
	# print("玩家：", player, " 注册武器：", weapon_name, " 武器槽索引：", slot_index)
	var slot = player.get_weapon_slot(slot_index) # 获取在玩家节点下的武器槽实例
	var instance = load(weapon_pool_item.resource_path).instantiate() # 加载武器资源
	# print_weapon_pool_item(weapon_pool_item)
	# 设置武器实例属性
	instance.slot = slot
	instance.slot_index = slot_index
	instance.player = player
	instance.player_stats = player.player_stats

	instance.weapon_level = weapon_pool_item.level
	
	var weapon_stats = instance.get_node("WeaponStats") # 这时候weapon还未ready，所以需要get_node来获取
	if weapon_stats.classes.has(AttributesManager.Classes.STATION):
		instance.position = activated_station_areas.get_random_position()
	else:
		instance.position = slot.global_position
	
	if instance not in players_weapons[player]:
		for _origin in weapon_stats.origins:
			player.update_origins_number(_origin,1)
		for _class in weapon_stats.classes:
			player.update_classes_number(_class,1)	
	
	players_weapons[player].append(instance)
	activated_level.add_child(instance)

func _on_player_unregister_weapon(player: CharacterBody2D, slot_index: int) -> void:
	'''
	注销武器

	:param player: 玩家
	:param slot_index: 武器槽索引
	:return: None
	'''
	# print("注销武器：", player, " 武器槽索引：", slot_index)
	for weapon in players_weapons[player]:
		if weapon.slot_index == slot_index:
			var weapon_stats = weapon.get_node("WeaponStats")
			
			players_weapons[player].erase(weapon)

			if weapon not in players_weapons[player]:
				for _origin in weapon_stats.origins:
					player.update_origins_number(_origin,-1)
				for _class in weapon_stats.classes:
					player.update_classes_number(_class,-1)	
			weapon.queue_free()

			break
