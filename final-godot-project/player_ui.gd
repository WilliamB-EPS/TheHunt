extends Control

var player

# Called when the node enters the scene tree for the first time.
func _ready():
	player = $".."/".."/Player
	if Globals.curr_level == 1:
		player.num_keys = 0
	elif Globals.curr_level == 2:
		player.num_keys = 2
		$UpdateUI/Label.text = "THIS LEVEL HAS NO INSTRUCTIONS\nEXPLORE THE MAP TO FIND WHAT YOU\nNEED AND HOW TO ESCAPE."	
		$ExitScreen/Label.text =  "THERE ARE NO OBJECTIVES \nFOR THIS LEVEL.\n EXPLORE THE MAP TO FIND \nUT HOW TO PROCEED.\n GOOD LUCK."	
	elif Globals.curr_level == 3:
		player.num_keys = 2
		get_node("InventoryContainer/Item3").visible = true
		$UpdateUI/Label.text = "WELCOME TO THE FINAL LEVEL. TO WIN, MOVE\nTHROUGH THE MAZE AND FIND THE ESCAPE. \nYOU CAN SPEND 1 KEY TO HIDE IN A CLOSET,\nWHERE THE ALIEN CAN'T FIND YOU.\nGOOD LUCK"	
		$ExitScreen/Label.text =  "OBJECTIVES: \n\n1. MOVE THORUGH THE MAZE \n2. FIND THE ENDING.\n3. HIDE IN CLOSETS TO AVOID THE ALIENS"	
		
	$UpdateUI.visible = true
	self.set_num_keys(player.num_keys)

func _physics_process(delta):
	if Input.is_action_pressed("showui") and player.can_move:
		$ExitScreen.visible = true

func show_interact():
	$InteractContainer.visible = true
	
func hide_interact():
	$InteractContainer.visible = false
	
func show_hide_UI():
	self.hide_interact()
	$HidingUI.visible = true
	player.num_keys -= 1
	set_num_keys(player.num_keys)

	
func npc_interact():
	$UpdateUI.visible = true
	$UpdateUI/Label.text = "I'M A DIRECTION, A PLACE TO SEEK\nWHERE THE SUN SETS AND SHADOWS SNEAK\nNOT QUITE NORTH, OR EAST, YOU SEE\nBUT A CORNER OF THE COMPASS IS WHERE I'LL BE\nAND TAKE THIS KEYCARD, IF SO TO SEE"
	get_node("InventoryContainer/Item3").visible = true
	
# increment num keys and show a message 
func set_num_keys(numkeys):
	if numkeys >= 1:
		$InventoryContainer/Item1.visible = true
		if numkeys >= 2:
			$InventoryContainer/Item2.visible = true
		else:
			$InventoryContainer/Item2.visible = false
	else: 
		$InventoryContainer/Item1.visible = false
	
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
	$HidingUI.visible = false
	
func game_win():
	$UpdateUI.visible = true
	$UpdateUI/quit_btn_art.visible = true
	$UpdateUI/quit_btn2.visible = true
	$UpdateUI/Button.visible = false
	$UpdateUI/Button13.visible = false
	if Globals.curr_level == 3:
		$UpdateUI/Label.text = "CONGRATULATIONS!\nYOU HAVE REACHED THE ESCAPE POD AND WON THE GAME!"
	else:
		$UpdateUI/Label.text = "YOU WON! LEVEL COMPLETE."
	
func reqs_message():
	hide_interact()
	$UpdateUI.visible = true
	$UpdateUI/Label.text = "INSUFFICIENT RESOURCES"

func _on_button_pressed():
	$UpdateUI.visible = false
	player.can_move = true


func _on_quit_btn_pressed():
	get_tree().change_scene_to_file("res://main_menu.tscn")


func _on_continue_btn_pressed():
	$ExitScreen.visible = false


func _on_stop_hiding_btn_pressed():
	$HidingUI.visible = false
	player.can_move = true
	$".."/".."/Player/AnimatedSprite2D.visible = true
	player.is_hiding = false
