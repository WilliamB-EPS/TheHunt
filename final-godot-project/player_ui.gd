extends Control


# Called when athe node enters the scene tree for the first time.
func _ready():
	call_deferred("actor_setup")
	
# bad to call await in ready(), so moving setup stuff here
# displays story background (will be more detailed later)
func actor_setup():
	await get_tree().physics_frame
	$".."/".."/Player.can_move = false
	$InteractContainer.visible = false
	$UpdateUI.visible = true
	$InventoryContainer/Item1.visible = false
	$InventoryContainer/Item2.visible = false
	$InventoryContainer/Item3.visible = false

func show_interact():
	$InteractContainer.visible = true
	
func hide_interact():
	$InteractContainer.visible = false
	
# increment num keys and show a message 
func set_num_keys(numkeys):
	get_node("InventoryContainer/Item" + str(numkeys)).visible = true
	
func show_blank_message():
	$UpdateUI.visible = true
	$UpdateUI/Label.text = "EMPTY BOX. NO KEYS"
	await get_tree().create_timer(1).timeout
	$UpdateUI.visible = false

func lose_screen():
	$UpdateUI.visible = true
	$UpdateUI/Label.text = "YOU DIED. GAME OVER"
	
func game_win():
	$UpdateUI.visible = true
	$UpdateUI/Label.text = "YOU WON! GAME OVER"
	
func reqs_message():
	hide_interact()
	$UpdateUI.visible = true
	$UpdateUI/Label.text = "INSUFFICIENT RESOURCES"
	await get_tree().create_timer(1).timeout
	show_interact()
	$UpdateUI.visible = false


func _on_button_pressed():
	$UpdateUI.visible = false
	$".."/".."/Player.can_move = true
