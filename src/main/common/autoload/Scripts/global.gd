extends Node

# Steam variables
var is_on_steam_deck: bool = false
var is_online: bool = false
var is_owned: bool = false
var steam_app_id: int = 480
var steam_id: int = 0
var steam_username: String = ""

func _init() -> void:
	# Set your game's Steam app ID here
	OS.set_environment("SteamAppId", str(steam_app_id))
	OS.set_environment("SteamGameId", str(steam_app_id))

func _ready() -> void:
	initialize_steam()

func _process(_delta: float) -> void:
	Steam.run_callbacks()

func initialize_steam() -> void:
	var initialize_response: Dictionary = Steam.steamInitEx()
	print("Did Steam initialize?: %s" % initialize_response)

	if initialize_response['status'] > 0:
		print("Failed to initialize Steam. Shutting down. %s" % initialize_response)
		get_tree().quit()

	# Gather additional data
	is_on_steam_deck = Steam.isSteamRunningOnSteamDeck()
	is_online = Steam.loggedOn()
	is_owned = Steam.isSubscribed()
	steam_id = Steam.getSteamID()
	steam_username = Steam.getPersonaName()


func change_scene(path: String, entry_point: String="EntryPoint") -> void:
	var tree := get_tree()
	tree.change_scene_to_file(path)
	await tree.process_frame
	
	
func show_online_mode_screen() -> void:
	$CanvasLayer/OnlineModeScreen.show_screen()
