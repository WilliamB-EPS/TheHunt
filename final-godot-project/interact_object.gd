extends Area2D

enum type {BLANK, KEY, OPENED, END}

@export 
var mytype = type.KEY # set the type of this interact object in the editor


func _on_body_entered(body):
	if body.get_name() == "Player":
		# opened objects can't be interacted with
		if self.mytype != type.OPENED:
			var playerui = $".."/CanvasLayer/PlayerUI.show_interact()
			# connect to the player node (everything will be handled there)
			$".."/Player.curr_interact_area = self


func _on_body_exited(body):
	if body.get_name() == "Player":
		$".."/CanvasLayer/PlayerUI.hide_interact()
		$".."/Player.curr_interact_area = null
		
func set_type(newtype):
	if newtype == "KEY":
		self.mytype = type.KEY
	elif newtype == "BLANK":
		self.mytype = type.BLANK
	else:
		assert(1 == 0, "INVALID TYPE ARGUMENT")
	
	
