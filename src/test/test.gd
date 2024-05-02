extends Node2D

class weapon_data:
	var id: int = 0
	var weapon_name = ""
	var resource_path = ""
	var icon_path = ""
	var level: int = 0
	var price: int = 10
	var max_quantity: int = -1
	var weapon_class: Attribute_Changed.Classes
	var weapon_origin: Attribute_Changed.Origins

var weapon_data_base: Array = []

func _ready() -> void:
	var excel = ExcelFile.open_file("res://src/main/WeaponDataBase.xlsx")
	var workbook = excel.get_workbook()

	var sheet = workbook.get_sheet(0)
	var table_data = sheet.get_table_data()
	for i in range(table_data.size()-1):
		var row_index = i + 2
		var data = {}
		for j in range(table_data[1].size()):
			data[table_data[1][j+1]] = table_data[row_index][j+1]
		weapon_data_base.append(data)
		
	print(weapon_data_base)

