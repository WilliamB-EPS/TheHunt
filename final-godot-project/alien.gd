extends CharacterBody2D

var movement_speed: float = 100.0
@onready var navigation_agent = $NavigationAgent2D
@onready var map = $".."/TileMap
@onready var player  = $".."/Player
enum State {ROAM, TRACK, ATTACK}
var state_time = 0.0
var curstate = State.ROAM
var just_entered_roam = true
var prev_positions = []
var stuck = false
var is_idle = false
var pos_dif

@export
var xmin = 100
@export
var xmax = 6000
@export
var ymin = 80
@export
var ymax = 1000

# prep by connecting to the tilemap and setting the initial target position
func _ready():
	navigation_agent.set_navigation_map(map)
	navigation_agent.set_target_position(Vector2(xmin + randi() % (xmax - xmin), ymin + randi() % (ymax - ymin)))
	
	
func switch_to(new_state: State):
	curstate = new_state
	state_time = 0.0
	# when we attack, stop the player from moving
	if new_state == State.ATTACK:	
		player.can_move = false
		$AnimatedSprite2D.frame = 0
		$AnimatedSprite2D.play("attack")
	# move slower when roaming
	elif new_state == State.ROAM:
		just_entered_roam = true
		movement_speed = 100.0
	# move faster when tracking
	elif new_state == State.TRACK:
		movement_speed = 170.0

func _physics_process(delta):	
	# addresses issue where alien gets stuck
	# basically, if we havent moved a lot in the last 20 frames,
	# signal that we're stuck and get a new target point
	pos_dif = 30.0
	self.prev_positions.append(self.position)
	if prev_positions.size() > 20:
		prev_positions.remove_at(0) 
	if prev_positions.size() == 20:
		pos_dif = (prev_positions[19] - prev_positions[0]).length()
		if pos_dif < 3:
			self.stuck = true
		
	if self.stuck and self.is_idle == false and curstate != State.ATTACK:
		switch_to(State.ROAM)
		self.stuck = false
		
	# state depends on distance from player
	elif curstate == State.TRACK:
		if player.is_hiding == true: # hiding in closet => roam
			switch_to(State.ROAM)
		elif (player.position - self.position).length() < 70:
			switch_to(State.ATTACK)
		elif (player.position - self.position).length() >= 500:
			switch_to(State.ROAM)
	elif curstate == State.ROAM:
		if (player.position - self.position).length() < 400:
			if player.is_hiding == false: # hiding means we must stay in roam
				switch_to(State.TRACK)

	if curstate == State.TRACK:
		navigation_agent.target_position = player.position
	# if we're roaming, get a new random position every 10 seconds
	elif curstate == State.ROAM and (state_time > 20.0 or just_entered_roam):
		navigation_agent.set_target_position(Vector2(xmin + randi() % (xmax - xmin), ymin + randi() % (ymax - ymin)))
		state_time = 0
		just_entered_roam = false
		
	# navigation2d movement (inspired by Godot documentation)
	if navigation_agent.distance_to_target() > 15:
		var new_velocity: Vector2 = navigation_agent.get_next_path_position() - global_position
		new_velocity = new_velocity.normalized() * movement_speed
		# we only play with the animations if we arent stuck/moving slowly
		# this prevents rapid direction switching when the alien gets stuck,
		# which makes the game loook buggy
		if curstate != State.ATTACK and pos_dif > 25.0:
			self.is_idle = false
			if new_velocity.x < 0:
				$AnimatedSprite2D.flip_h = true
				$AnimatedSprite2D.play("walk_right")
			else:
				$AnimatedSprite2D.flip_h = false
				$AnimatedSprite2D.play("walk_right")
		velocity = new_velocity
		move_and_slide()
	elif curstate != State.ATTACK:
		self.is_idle = true
		if velocity.x < 0:
			$AnimatedSprite2D.flip_h = true
			$AnimatedSprite2D.play("idle")
		else:
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play("idle")

	state_time += delta
	
		

func _on_animated_sprite_2d_animation_finished():
	# Change states if needed once animations finish
	if curstate == State.ATTACK:
		# game is over (one hit kills)
		# lockup the alien and player
		$".."/CanvasLayer/PlayerUI.hide_interact()
		$".."/AnimationPlayer.play("shader_death")
		await $".."/AnimationPlayer.animation_finished
		$".."/CanvasLayer/PlayerUI.lose_screen()
