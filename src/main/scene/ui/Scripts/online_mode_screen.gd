extends Control

@onready var tab_bar: TabBar = $HostSettings/VBoxContainer/MaxPlayersHbox/TabBar
@onready var lobby_name: TextEdit = $HostSettings/VBoxContainer/HostNameHbox/TextEdit
@onready var lobby_password: TextEdit = $HostSettings/VBoxContainer/PassWordHbox/TextEdit
@onready var create_lobby_button: Button = $HostSettings/StartAsHost
@onready var refresh_lobby_button: Button = $Lobbies/HBoxContainer/Refresh

@onready var password_check_button: CheckButton = $HostSettings/VBoxContainer/CheckPassWordHbox/CheckButton
@onready var password_hbox: HBoxContainer = $HostSettings/VBoxContainer/PassWordHbox

enum State {
	HOST_OR_JOIN,
	HOST_SETTING,
	LOBBIES
}

var current_state = State.HOST_OR_JOIN

func init_control() -> void:
	hide()
	scale = Vector2.ZERO
	$HostSettings.hide()
	$Lobbies.hide()
	for i in range(4):
		tab_bar.add_tab(str(4-i))
	lobby_name.text = Global.steam_username + "'s Lobby"
	
	password_hbox.hide()

const PACKET_READ_LIMIT: int = 32

var lobby_data
var lobby_id: int = 0
var lobby_members: Array = []
var lobby_members_max: int = 10
var lobby_vote_kick: bool = false
var steam_id: int = 0
var steam_username: String = ""

var lobby_button_list: Array = []

func _ready() -> void:
	await owner.ready

	steam_id = Global.steam_id
	steam_username = Global.steam_username

	print("获取到的steam_id: %s" % steam_id)
	print("获取到的steam_username: %s" % steam_username)


	Steam.join_requested.connect(_on_lobby_join_requested)
	Steam.lobby_chat_update.connect(_on_lobby_chat_update)
	Steam.lobby_created.connect(_on_lobby_created)
	Steam.lobby_data_update.connect(_on_lobby_data_update)
	Steam.lobby_invite.connect(_on_lobby_invite)
	Steam.lobby_joined.connect(_on_lobby_joined)
	Steam.lobby_match_list.connect(_on_lobby_match_list)
	Steam.lobby_message.connect(_on_lobby_message)
	Steam.persona_state_change.connect(_on_persona_change)
	
	Steam.p2p_session_request.connect(_on_p2p_session_request)
	Steam.p2p_session_connect_fail.connect(_on_p2p_session_connect_fail)
	
	# Check for command line arguments
	check_command_line()
	
	init_control()
	
func _process(delta: float) -> void:
	# If the player is connected, read packets
	if lobby_id > 0:
		read_all_p2p_packets()


func read_all_p2p_packets(read_count: int = 0):
	if read_count >= PACKET_READ_LIMIT:
		return

	if Steam.getAvailableP2PPacketSize(0) > 0:
		read_p2p_packet()
		read_all_p2p_packets(read_count + 1)


func check_command_line() -> void:
	var these_arguments: Array = OS.get_cmdline_args()

	# There are arguments to process
	if these_arguments.size() > 0:

		# A Steam connection argument exists
		if these_arguments[0] == "+connect_lobby":

			# Lobby invite exists so try to connect to it
			if int(these_arguments[1]) > 0:

				# At this point, you'll probably want to change scenes
				# Something like a loading into lobby screen
				print("Command line lobby ID: %s" % these_arguments[1])
				join_lobby(int(these_arguments[1]))

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 大厅 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
func create_lobby() -> void:
	# Make sure a lobby is not already set
	print("Current Lobby ID: %s" % lobby_id)
	if lobby_id == 0:
		print("Creating a lobby...")
		Steam.createLobby(Steam.LOBBY_TYPE_PUBLIC, 4-tab_bar.current_tab)
		
func get_lobbies() -> void:
	# 清除之前的大厅按钮
	for this_button in lobby_button_list:
		this_button.queue_free()

	# Set distance to worldwide
	Steam.addRequestLobbyListDistanceFilter(Steam.LOBBY_DISTANCE_FILTER_WORLDWIDE)
	Steam.addRequestLobbyListStringFilter("mysterious_code", "51522zzwlwlbb", Steam.LOBBY_COMPARISON_EQUAL)

	print("Requesting a lobby list")
	Steam.requestLobbyList()
	
func join_lobby(this_lobby_id: int) -> void:
	print("Attempting to join lobby %s" % this_lobby_id)

	# Clear any previous lobby members lists, if you were in a previous lobby
	lobby_members.clear()

	# Make the lobby join request to Steam
	Steam.joinLobby(this_lobby_id)
	
func get_lobby_members() -> void:
	# Clear your previous lobby list
	lobby_members.clear()

	# Get the number of members from this lobby from Steam
	var num_of_members: int = Steam.getNumLobbyMembers(lobby_id)

	print("Lobby %s has %s members" % [lobby_id, num_of_members])

	# Get the data of these players from Steam
	for this_member in range(0, num_of_members):
		# Get the member's Steam ID
		var member_steam_id: int = Steam.getLobbyMemberByIndex(lobby_id, this_member)

		# Get the member's Steam name
		var member_steam_name: String = Steam.getFriendPersonaName(member_steam_id)

		# print("Member %s: %s" % [member_steam_id, member_steam_name])

		# Add them to the list
		lobby_members.append({"steam_id":member_steam_id, "steam_name":member_steam_name})

# A user's information has changed
func _on_persona_change(this_steam_id: int, _flag: int) -> void:
	# Make sure you're in a lobby and this user is valid or Steam might spam your console log
	if lobby_id > 0:
		print("A user (%s) had information change, update the lobby list" % this_steam_id)

		# Update the player list
		get_lobby_members()
		

func _on_lobby_join_requested(this_lobby_id: int, friend_id: int) -> void:
	# Get the lobby owner's name
	var owner_name: String = Steam.getFriendPersonaName(friend_id)

	print("Joining %s's lobby..." % owner_name)

	# Attempt to join the lobby
	join_lobby(this_lobby_id)

func _on_lobby_chat_update(this_lobby_id: int, change_id: int, making_change_id: int, chat_state: int) -> void:
	# Get the user who has made the lobby change
	var changer_name: String = Steam.getFriendPersonaName(change_id)

	# If a player has joined the lobby
	if chat_state == Steam.CHAT_MEMBER_STATE_CHANGE_ENTERED:
		print("%s has joined the lobby." % changer_name)

	# Else if a player has left the lobby
	elif chat_state == Steam.CHAT_MEMBER_STATE_CHANGE_LEFT:
		print("%s has left the lobby." % changer_name)

	# Else if a player has been kicked
	elif chat_state == Steam.CHAT_MEMBER_STATE_CHANGE_KICKED:
		print("%s has been kicked from the lobby." % changer_name)

	# Else if a player has been banned
	elif chat_state == Steam.CHAT_MEMBER_STATE_CHANGE_BANNED:
		print("%s has been banned from the lobby." % changer_name)

	# Else there was some unknown change
	else:
		print("%s did... something." % changer_name)

	# Update the lobby now that a change has occurred
	get_lobby_members()

func _on_lobby_created(connect: int, this_lobby_id: int) -> void:
	if connect == 1:
		# Set the lobby ID
		lobby_id = this_lobby_id
		print("Created a lobby: %s" % lobby_id)

		# Set this lobby as joinable, just in case, though this should be done by default
		Steam.setLobbyJoinable(lobby_id, true)

		# Set some lobby data
		Steam.setLobbyData(lobby_id, "name", lobby_name.text)
		if password_check_button.button_pressed:
			Steam.setLobbyData(lobby_id, "password", lobby_password.text)
		else:
			Steam.setLobbyData(lobby_id, "password", "")
		Steam.setLobbyData(lobby_id, "mysterious_code", "51522zzwlwlbb")
		

		# Allow P2P connections to fallback to being relayed through Steam if needed
		var set_relay: bool = Steam.allowP2PPacketRelay(true)
		print("Allowing Steam to be relay backup: %s" % set_relay)

		# 将创建lobby的按钮设置为可用
		create_lobby_button.text = "Leave Lobby"
		create_lobby_button.disabled = false

func _on_lobby_data_update(lobby_id: int, member_id: int) -> void:
	pass

func _on_lobby_invite(lobby_id: int, steam_id: int) -> void:
	pass

func _on_lobby_joined(this_lobby_id: int, _permissions: int, _locked: bool, response: int) -> void:
	# If joining was successful
	if response == Steam.CHAT_ROOM_ENTER_RESPONSE_SUCCESS:
		# Set this lobby ID as your lobby ID
		lobby_id = this_lobby_id

		# Get the lobby members
		get_lobby_members()

		# Make the initial handshake
		make_p2p_handshake()

	# Else it failed for some reason
	else:
		# Get the failure reason
		var fail_reason: String

		match response:
			Steam.CHAT_ROOM_ENTER_RESPONSE_DOESNT_EXIST: fail_reason = "This lobby no longer exists."
			Steam.CHAT_ROOM_ENTER_RESPONSE_NOT_ALLOWED: fail_reason = "You don't have permission to join this lobby."
			Steam.CHAT_ROOM_ENTER_RESPONSE_FULL: fail_reason = "The lobby is now full."
			Steam.CHAT_ROOM_ENTER_RESPONSE_ERROR: fail_reason = "Uh... something unexpected happened!"
			Steam.CHAT_ROOM_ENTER_RESPONSE_BANNED: fail_reason = "You are banned from this lobby."
			Steam.CHAT_ROOM_ENTER_RESPONSE_LIMITED: fail_reason = "You cannot join due to having a limited account."
			Steam.CHAT_ROOM_ENTER_RESPONSE_CLAN_DISABLED: fail_reason = "This lobby is locked or disabled."
			Steam.CHAT_ROOM_ENTER_RESPONSE_COMMUNITY_BAN: fail_reason = "This lobby is community locked."
			Steam.CHAT_ROOM_ENTER_RESPONSE_MEMBER_BLOCKED_YOU: fail_reason = "A user in the lobby has blocked you from joining."
			Steam.CHAT_ROOM_ENTER_RESPONSE_YOU_BLOCKED_MEMBER: fail_reason = "A user you have blocked is in the lobby."

		print("Failed to join this chat room: %s" % fail_reason)

		#Reopen the lobby list
		get_lobbies()

func _on_lobby_match_list(these_lobbies: Array) -> void:
	# 清除之前的大厅按钮
	lobby_button_list.clear()

	if these_lobbies.size() == 0:
		$Lobbies/ScrollContainer/ItemList/Label.show()
	else:
		$Lobbies/ScrollContainer/ItemList/Label.hide()
	for this_lobby in these_lobbies:
		# Pull lobby data from Steam, these are specific to our example
		var this_lobby_name: String = Steam.getLobbyData(this_lobby, "name")
		var this_lobby_password: String = Steam.getLobbyData(this_lobby, "password")

		# Get the current number of members
		var lobby_num_members: int = Steam.getNumLobbyMembers(this_lobby)
		var lobby_max_members: int = Steam.getLobbyMemberLimit(this_lobby)

		var button_text: String
		if this_lobby_password != "":
			button_text = "%s - %s/%s Player(s) - Password Protected" % [this_lobby_name, lobby_num_members, lobby_max_members]
		else:
			button_text = "%s - %s/%s Player(s)" % [this_lobby_name, lobby_num_members, lobby_max_members]


		# Create a button for the lobby
		var lobby_button: Button = Button.new()
		lobby_button.set_text(button_text)
		lobby_button.set_size(Vector2(300, 50))
		lobby_button.set_name("lobby_%s" % this_lobby)
		lobby_button.connect("pressed", Callable(self, "join_lobby").bind(this_lobby))
		lobby_button.add_theme_font_size_override("font_size", 12)

		lobby_button_list.append(lobby_button)

		# Add the new lobby to the list
		$Lobbies/ScrollContainer/ItemList.add_child(lobby_button)

func _on_lobby_message(lobby_id: int, member_id: int, message: String) -> void:
	pass

func leave_lobby() -> void:
	# If in a lobby, leave it
	if lobby_id != 0:
		print("Leaving lobby %s" % lobby_id)
		# Send leave request to Steam
		Steam.leaveLobby(lobby_id)

		# Wipe the Steam lobby ID then display the default lobby ID and player list title
		lobby_id = 0

		# Close session with all users
		for this_member in lobby_members:
			# Make sure this isn't your Steam ID
			if this_member['steam_id'] != steam_id:

				# Close the P2P session
				Steam.closeP2PSessionWithUser(this_member['steam_id'])

		# Clear the local lobby list
		lobby_members.clear()

		print("Left the lobby.")
		# 将创建lobby的按钮设置为可用
		create_lobby_button.text = "Create Lobby"
		create_lobby_button.disabled = false

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> P2P >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
func make_p2p_handshake() -> void:
	print("Sending P2P handshake to the lobby")

	send_p2p_packet(0, {"message": "handshake", "from": steam_id})

func _on_p2p_session_request(remote_id: int) -> void:
	# Get the requester's name
	var this_requester: String = Steam.getFriendPersonaName(remote_id)
	print("%s is requesting a P2P session" % this_requester)

	# Accept the P2P session; can apply logic to deny this request if needed
	Steam.acceptP2PSessionWithUser(remote_id)

	# Make the initial handshake
	make_p2p_handshake()

func read_p2p_packet() -> void:
	var packet_size: int = Steam.getAvailableP2PPacketSize(0)

	# There is a packet
	if packet_size > 0:
		print("Reading a packet of size %s" % packet_size)
		var this_packet: Dictionary = Steam.readP2PPacket(packet_size, 0)

		if this_packet.is_empty() or this_packet == null:
			print("WARNING: read an empty packet with non-zero size!")

		# Get the remote user's ID
		var packet_sender: int = this_packet['steam_id_remote']

		# Make the packet data readable
		var packet_code: PackedByteArray = this_packet['data']

		# Decompress the array before turning it into a useable dictionary
		var readable_data: Dictionary = bytes_to_var(packet_code.decompress_dynamic(-1, FileAccess.COMPRESSION_GZIP))

		# Print the packet to output
		print("Packet: %s" % readable_data)

		# Append logic here to deal with packet data

func send_p2p_packet(target: int, packet_data: Dictionary) -> void:
	# Set the send_type and channel
	var send_type: int = Steam.P2P_SEND_RELIABLE
	var channel: int = 0

	# Create a data array to send the data through
	var this_data: PackedByteArray

	# Compress the PackedByteArray we create from our dictionary  using the GZIP compression method
	var compressed_data: PackedByteArray = var_to_bytes(packet_data).compress(FileAccess.COMPRESSION_GZIP)
	this_data.append_array(compressed_data)

	# If sending a packet to everyone
	if target == 0:
		# Loop through all members that aren't you
		for this_member in lobby_members:
			if this_member['steam_id'] != steam_id:
				Steam.sendP2PPacket(this_member['steam_id'], this_data, send_type, channel)

	# Else send it to someone specific
	else:
		Steam.sendP2PPacket(target, this_data, send_type, channel)

func _on_p2p_session_connect_fail(steam_id: int, session_error: int) -> void:
	# If no error was given
	if session_error == 0:
		print("WARNING: Session failure with %s: no error given" % steam_id)

	# Else if target user was not running the same game
	elif session_error == 1:
		print("WARNING: Session failure with %s: target user not running the same game" % steam_id)

	# Else if local user doesn't own app / game
	elif session_error == 2:
		print("WARNING: Session failure with %s: local user doesn't own app / game" % steam_id)

	# Else if target user isn't connected to Steam
	elif session_error == 3:
		print("WARNING: Session failure with %s: target user isn't connected to Steam" % steam_id)

	# Else if connection timed out
	elif session_error == 4:
		print("WARNING: Session failure with %s: connection timed out" % steam_id)

	# Else if unused
	elif session_error == 5:
		print("WARNING: Session failure with %s: unused" % steam_id)

	# Else no known error
	else:
		print("WARNING: Session failure with %s: unknown error %s" % [steam_id, session_error])

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 显示控件 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

func show_screen() -> void:
	show()

	var tween_time: float = 0.5
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(self, "scale", Vector2.ONE, tween_time).from(Vector2.ZERO)

	await tween.finished
	current_state = State.HOST_OR_JOIN
	

func hide_screen() -> void:
	var tween_time: float = 0.5
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(self, "scale", Vector2.ZERO, tween_time).from(Vector2.ONE)

	await tween.finished
	hide()
	current_state = State.HOST_OR_JOIN

func _on_host_game_pressed() -> void:
	$HostSettings.show()
	var tween_time: float = 0.5
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween.parallel().tween_property($HostOrJoinVbox, "scale", Vector2.ZERO, tween_time).from(Vector2.ONE)
	tween.parallel().tween_property($HostSettings, "modulate:a", 1.0, tween_time).from(0.0)

	await tween.finished
	current_state = State.HOST_SETTING


func _on_join_game_pressed() -> void:
	get_lobbies()
	
	$Lobbies.show()
	var tween_time: float = 0.5
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween.parallel().tween_property($HostOrJoinVbox, "scale", Vector2.ZERO, tween_time).from(Vector2.ONE)
	tween.parallel().tween_property($Lobbies, "modulate:a", 1.0, tween_time).from(0.0)

	await tween.finished
	current_state = State.LOBBIES


func _unhandled_input(event: InputEvent) -> void:
	if not visible:
		return
	if event.is_action_pressed("esc"):
		get_viewport().set_input_as_handled()
		match current_state:
			State.HOST_OR_JOIN:
				hide_screen()
			State.HOST_SETTING:
				var tween_time: float = 0.5
				var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_ELASTIC)
				tween.parallel().tween_property($HostOrJoinVbox, "scale", Vector2.ONE, tween_time).from(Vector2.ZERO)
				tween.parallel().tween_property($HostSettings, "modulate:a", 0.0, tween_time).from(1.0)
				await tween.finished
				$HostSettings.hide()
				current_state = State.HOST_OR_JOIN
			State.LOBBIES:
				var tween_time: float = 0.5
				var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_ELASTIC)
				tween.parallel().tween_property($HostOrJoinVbox, "scale", Vector2.ONE, tween_time).from(Vector2.ZERO)
				tween.parallel().tween_property($Lobbies, "modulate:a", 0.0, tween_time).from(1.0)
				await tween.finished
				$Lobbies.hide()
				current_state = State.HOST_OR_JOIN
	 
	
func _on_start_as_host_pressed() -> void:
	# 将创建lobby的按钮设置为不可用， 防止重复点击
	create_lobby_button.disabled = true
	if lobby_id == 0:
		create_lobby_button.text = "Creating Lobby..."
		create_lobby()
	else:
		create_lobby_button.text = "Leaving Lobby..."
		leave_lobby()

func _on_check_button_toggled(toggled_on: bool) -> void:
	password_hbox.visible = toggled_on

func _on_refresh_pressed() -> void:
	get_lobbies()
