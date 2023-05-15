extends Control


# Called when athe node enters the scene tree for the first time.
func _ready():
	$InteractContainer.visible = false
	$InteractBG.visible = false
	$UpdateBG.visible = false
	$UpdateContainer.visible = false

func show_interact():
	$InteractContainer.visible = true
	$InteractBG.visible = true
	
func hide_interact():
	$InteractContainer.visible = false
	$InteractBG.visible = false
	
func set_num_keys(numkeys):
	$InventoryBG.visible = true
	$InventoryContainer.visible = true
	$InventoryContainer/Label.text = "Inventory: " + str(numkeys) + " keys"
	$UpdateBG.visible = true
	$UpdateContainer.visible = true
	$UpdateContainer/Label.text = "You just found a key!"
	await get_tree().create_timer(1).timeout
	$UpdateBG.visible = false
	$UpdateContainer.visible = false
	
func show_blank_message():
	$UpdateBG.visible = true
	$UpdateContainer.visible = true
	$UpdateContainer/Label.text = "Empty box - no keys"
	await get_tree().create_timer(1).timeout
	$UpdateBG.visible = false
	$UpdateContainer.visible = false

func lose_screen():
	$UpdateBG.visible = true
	$UpdateContainer.visible = true
	$UpdateContainer/Label.text = "You died. Game over"
	
