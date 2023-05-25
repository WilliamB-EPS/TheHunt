extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var random = RandomNumberGenerator.new()
	random.randomize()
	var idx1 = random.randi_range(1, 6)
	var idx2 = random.randi_range(1, 6)
	while idx1 == idx2:
		idx2 = random.randi_range(1, 6)
	var idx3 = random.randi_range(1, 6)
	while idx3 == idx2 or idx3 == idx1 :
		idx3 = random.randi_range(1, 6)
		
	print(idx1)
	print(idx2)
	print(idx3)

	for i in range(1, 7):
		var interact_node = get_node("InteractObject" + str(i))
		if i == idx1 or i == idx2 or i == idx3:
			interact_node.set_type("KEY")
		else:
			interact_node.set_type("BLANK")
			
