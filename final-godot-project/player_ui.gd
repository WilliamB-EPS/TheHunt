extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$".."/".."/Player.can_move = false
	if Globals.curr_level == 2:
		$UpdateUI/Label.text = "THIS LEVEL HAS NO INSTRUCTIONS\nEXPLORE THE MAP TO FIND WHAT YOU\nNEED AND HOW TO ESCAPE."	
	$UpdateUI.visible = true
	self.set_num_keys(Globals.num_keys)

func _physics_process(delta):
	if Input.is_action_pressed("showui") and $".."/".."/Player.can_move:
		$ExitScreen.visible = true

func show_interact():
	$InteractContainer.visible = true
	
func hide_interact():
	$InteractContainer.visible = false
	
func npc_interact():
	$UpdateUI.visible = true
	$UpdateUI/Label.text = "I'M A DIRECTION, A PLACE TO SEEK\nWHERE THE SUN SETS AND SHADOWS SNEAK\nNOT QUITE NORTH, OR EAST, YOU SEE\nBUT A CORNER OF THE COMPASS IS WHERE I'LL BE\nAND TAKE THIS KEYCARD, IF SO TO SEE"
	get_node("InventoryContainer/Item3").visible = true
	
# increment num keys and show a message 
func set_num_keys(numkeys):
	for i in range(1, numkeys + 1):
		get_node("InventoryContainer/Item" + str(i)).visible = true
	
func show_blank_message():
	$UpdateUI.visible = true
	$UpdateUI/Label.text = "EMPTY BOX. NO KEYS"

func lose_screen():
	$UpdateUI.visible = true
	$UpdateUI/quit_btn_art.visible = true
	$UpdateUI/quit_btn2.visible = true
	$UpdateUI/Button.visible = false
	$UpdateUI/Button13.visible = false
	$UpdateUI/Label.text = "YOU DIED. RESTART THIS LEVEL."
	
func game_win():
	$UpdateUI.visible = true
	$UpdateUI/quit_btn_art.visible = true
	$UpdateUI/quit_btn2.visible = true
	$UpdateUI/Button.visible = false
	$UpdateUI/Button13.visible = false
	$UpdateUI/Label.text = "YOU WON! LEVEL COMPLETE."
	
func reqs_message():
	hide_interact()
	$UpdateUI.visible = true
	$UpdateUI/Label.text = "INSUFFICIENT RESOURCES"

func _on_button_pressed():
	$UpdateUI.visible = false
	$".."/".."/Player.can_move = true


func _on_quit_btn_pressed():
	get_tree().change_scene_to_file("res://main_menu.tscn")


func _on_continue_btn_pressed():
	$ExitScreen.visible = false
