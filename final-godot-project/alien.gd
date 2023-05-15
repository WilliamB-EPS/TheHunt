extends CharacterBody2D

var movement_speed: float = 100.0
@onready var navigation_agent = $NavigationAgent2D
@onready var map = $".."/TileMap
@onready var player  = $".."/Player
enum State {ROAM, TRACK, ATTACK}
var state_time = 0.0
var curstate = State.ROAM
var just_entered_roam = true

func _ready():
	navigation_agent.set_navigation_map(map)
	curstate = State.ROAM
	navigation_agent.set_target_position(Vector2(100 + randi() % 6000, 80 + randi() % 1000))
	
func switch_to(new_state: State):
	curstate = new_state
	state_time = 0.0
	if new_state == State.ATTACK:	
		player.can_move = false
		$AnimatedSprite2D.frame = 0
		$AnimatedSprite2D.play("attack")
	elif new_state == State.ROAM:
		just_entered_roam = true
		movement_speed = 100.0
	elif new_state == State.TRACK:
		movement_speed = 180.0

func _physics_process(delta):
	if curstate == State.TRACK and (player.position - self.position).length() < 100:
		switch_to(State.ATTACK)
	if curstate == State.ROAM and (player.position - self.position).length() < 400:
		switch_to(State.TRACK)
	elif curstate == State.TRACK and (player.position - self.position).length() >= 500:
		switch_to(State.ROAM)
	
	
	if curstate == State.TRACK:
		navigation_agent.target_position = player.position
	elif curstate == State.ROAM and (state_time > 10.0 or just_entered_roam):
		navigation_agent.set_target_position(Vector2(100 + randi() % 6000, 80 + randi() % 1000))
		state_time = 0
		just_entered_roam = false
		
	
	if navigation_agent.distance_to_target() > 2:
		var new_velocity: Vector2 = navigation_agent.get_next_path_position() - global_position
		new_velocity = new_velocity.normalized() * movement_speed
		
		if curstate != State.ATTACK:
			if new_velocity.x < 0:
				$AnimatedSprite2D.play("walk_right")
				$AnimatedSprite2D.flip_h = true
			else:
				$AnimatedSprite2D.play("walk_right")
				$AnimatedSprite2D.flip_h = false

		velocity = new_velocity
		move_and_slide()
	state_time += delta
		

func _on_animated_sprite_2d_animation_finished():
	# Change states if needed once animations finish
	if curstate == State.ATTACK:
		player.queue_free()
		self.queue_free()
		$".."/CanvasLayer/PlayerUI.lose_screen()
		switch_to(State.TRACK)
