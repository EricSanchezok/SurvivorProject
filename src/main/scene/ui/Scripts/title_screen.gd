extends Control


func _ready() -> void:
	$MainTitleControl.show()
	$ModesControl.hide()
	
	$ModesControl/HostOrJoinVbox.scale = Vector2.ZERO
	
	$HostSettings.hide()
	$HostSettings/VBoxContainer/PassWordHbox.hide()
	
	$Lobbies.hide()
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 主标题界面 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
func _on_start_game_pressed() -> void:
	$MainTitleControl.hide()
	$ModesControl.show()
	
	var tween_time: float = 0.5
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween.parallel().tween_property($ModesControl/ModeSelection, "scale", Vector2.ONE, tween_time).from(Vector2.ZERO)



func _on_settings_pressed() -> void:
	pass # Replace with function body.


func _on_quit_pressed() -> void:
	pass # Replace with function body.


# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 游戏模式选择界面 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
func _on_single_player_pressed() -> void:
	pass # Replace with function body.


func _on_online_multiplayer_pressed() -> void:
	$ModesControl/ExitModeSelection.hide()
	var tween_time: float = 0.5
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween.parallel().tween_property($ModesControl/ModeSelection, "scale", Vector2.ZERO, tween_time).from(Vector2.ONE)
	tween.parallel().tween_property($ModesControl/HostOrJoinVbox, "scale", Vector2.ONE, tween_time).from(Vector2.ZERO)
	
func _on_host_game_pressed() -> void:
	$HostSettings.show()
	var tween_time: float = 0.5
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween.parallel().tween_property($ModesControl/HostOrJoinVbox, "scale", Vector2.ZERO, tween_time).from(Vector2.ONE)
	tween.parallel().tween_property($HostSettings, "modulate:a", 1.0, tween_time).from(0.0)


func _on_join_game_pressed() -> void:
	$Lobbies.show()
	var tween_time: float = 0.5
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween.parallel().tween_property($ModesControl/HostOrJoinVbox, "scale", Vector2.ZERO, tween_time).from(Vector2.ONE)
	tween.parallel().tween_property($Lobbies, "modulate:a", 1.0, tween_time).from(0.0)
	
	
func _on_back_to_mode_selection_pressed() -> void:
	$ModesControl/ExitModeSelection.show()
	var tween_time: float = 0.5
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween.parallel().tween_property($ModesControl/ModeSelection, "scale", Vector2.ONE, tween_time).from(Vector2.ZERO)
	tween.parallel().tween_property($ModesControl/HostOrJoinVbox, "scale", Vector2.ZERO, tween_time).from(Vector2.ONE)


func _on_exit_mode_selection_pressed() -> void:
	var tween_time: float = 0.5
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween.parallel().tween_property($ModesControl/ModeSelection, "scale", Vector2.ZERO, tween_time).from(Vector2.ONE)
	
	await tween.finished
	$ModesControl.hide()
	$MainTitleControl.show()

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> HOST 界面 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

func _on_check_button_toggled(toggled_on: bool) -> void:
	$HostSettings/VBoxContainer/PassWordHbox.visible = toggled_on

func _on_start_as_host_pressed() -> void:
	pass # Replace with function body.

func _on_back_to_host_or_join_pressed() -> void:
	var tween_time: float = 0.5
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween.parallel().tween_property($ModesControl/HostOrJoinVbox, "scale", Vector2.ONE, tween_time).from(Vector2.ZERO)
	tween.parallel().tween_property($HostSettings, "modulate:a", 0.0, tween_time).from(1.0)
	
	await tween.finished
	$HostSettings.hide()





# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> JOIN 界面 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


func _on_back_to_host_or_join_from_join_pressed() -> void:
	var tween_time: float = 0.5
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween.parallel().tween_property($ModesControl/HostOrJoinVbox, "scale", Vector2.ONE, tween_time).from(Vector2.ZERO)
	tween.parallel().tween_property($Lobbies, "modulate:a", 0.0, tween_time).from(1.0)
	
	await tween.finished
	$Lobbies.hide()
