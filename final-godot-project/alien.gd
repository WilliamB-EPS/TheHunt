extends CharacterBody2D

var movement_speed: float = 100.0
@onready var navigation_agent = $NavigationAgent2D
@onready var map = $".."/TileMap
@onready var player  = $".."/Player
enum State {ROAM, TRACK, ATTACK}
var state_time = 0.0
var curstate = State.ROAM
var just_entered_roam = true
var prev_pos = self.position

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
	# state depends on distance from player
	if player.is_hiding == true:
		switch_to(State.ROAM)
	elif curstate == State.TRACK:
		if (player.position - self.position).length() < 70:
			switch_to(State.ATTACK)
		elif (player.position - self.position).length() >= 500:
			switch_to(State.ROAM)
	elif curstate == State.ROAM:
		if (player.position - self.position).length() < 400:
			switch_to(State.TRACK)

	if curstate == State.TRACK:
		navigation_agent.target_position = player.position
	# if we're roaming, get a new random position every 10 seconds
	elif curstate == State.ROAM and (state_time > 20.0 or just_entered_roam):
		navigation_agent.set_target_position(Vector2(xmin + randi() % (xmax - xmin), ymin + randi() % (ymax - ymin)))
		state_time = 0
		just_entered_roam = false
		
	# navigation2d movement (inspired by Godot documentation)
	if navigation_agent.distance_to_target() > 10:
		var new_velocity: Vector2 = navigation_agent.get_next_path_position() - global_position
		new_velocity = new_velocity.normalized() * movement_speed
		if curstate != State.ATTACK:
			if new_velocity.x < 0:
				$AnimatedSprite2D.flip_h = true
				if abs(new_velocity.length()) < 10:
					$AnimatedSprite2D.play("idle")
				else:
					$AnimatedSprite2D.play("walk_right")
			else:
				$AnimatedSprite2D.flip_h = false
				if abs(new_velocity.length()) < 10:
					$AnimatedSprite2D.play("idle")
				else:
					$AnimatedSprite2D.play("walk_right")
		velocity = new_velocity
		move_and_slide()
	elif curstate != State.ATTACK:
		if velocity.x < 0:
			$AnimatedSprite2D.flip_h = true
			$AnimatedSprite2D.play("idle")
		else:
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play("idle")
			
	prev_pos = self.position

	state_time += delta
		

func _on_animated_sprite_2d_animation_finished():
	# Change states if needed once animations finish
	if curstate == State.ATTACK:
		# game is over (one hit kills)
		# lockup the alien and player
		$".."/AnimationPlayer.play("shader_death")
		await $".."/AnimationPlayer.animation_finished
		$".."/CanvasLayer/PlayerUI.lose_screen()
