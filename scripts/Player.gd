extends KinematicBody2D


export(AudioStreamSample) var jump_sound
export(AudioStreamSample) var impulse_sound

const SPEED = 500
const GRAVITY = 1500
const GRAVITY_INCREMENT = 2500
const JUMP_FORCE = 40
const JUMP_DECREMENT = 100

onready var audio = $Audio
onready var animation = $AnimatedSprite

var screen_width
var half_sprite_width
var is_jumping = false
var current_jump_force = 0
var current_gravity = 0
var highest_reached_position = 300
var death_position_offset = 1200
var score = 0


signal jumped



func _ready():
	_compute_score()
	screen_width = get_viewport_rect().size.x
	half_sprite_width = animation.frames.get_frame("idle", 0).get_width() / 2
	current_gravity = GRAVITY
	audio.stream = jump_sound


func _process(delta):
	if !is_jumping:
		_increment_gravity(delta)
		position.y += current_gravity * delta
	else:
		position.y -= current_jump_force
		_decrement_jump_force(delta)
	
	highest_reached_position = position.y if position.y < highest_reached_position else highest_reached_position
	if position.y >= highest_reached_position + death_position_offset:
		die()
	
	if Input.is_action_pressed("ui_left"):
		position.x -= SPEED * delta
	elif Input.is_action_pressed("ui_right"):
		position.x += SPEED * delta
	elif Input.is_action_pressed("ui_accept"):
		jump()
	
	_compute_score()
	_check_boundaries()


func _compute_score():
	score = max(int(abs(highest_reached_position - 300)) / 15, 0)


func die():
	PlayerData.save_highscore(score)
	LevelManager.change_scene("Menu")


func jump():
	if is_jumping:
		return
	
	is_jumping = true
	current_gravity = 0
	current_jump_force = JUMP_FORCE
	audio.stream = jump_sound
	audio.play()
	animation.play("jump")
	emit_signal("jumped")


func add_impulse(impulse):
	is_jumping = true
	current_gravity = 0
	current_jump_force = impulse
	audio.stream = impulse_sound
	audio.play()
	animation.play("jump")
	emit_signal("jumped")


func _increment_gravity(delta):
	current_gravity += GRAVITY_INCREMENT * delta
	if current_gravity >= GRAVITY:
		current_gravity = GRAVITY


func _decrement_jump_force(delta):
	current_jump_force -= JUMP_DECREMENT * delta
	if current_jump_force <= 0:
		current_jump_force = 0
		is_jumping = false
		animation.play("idle")


func _check_boundaries():
	if position.x > screen_width:
		position.x = 0
	elif position.x < 0:
		position.x = screen_width