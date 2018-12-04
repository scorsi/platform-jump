extends Node


export(Array) var platforms
export(Array) var special_platforms

const MIN_INTERVAL = 100
const MAX_INTERVAL = 250
const INITIAL_PLATFORMS_COUNT = 30
const SPECIAL_PLATFORM_CHANCE = 20
const PLATFORM_GENERATION_OFFSET = 1000

onready var player = $Player
onready var score_text = $UI/Score

var current_max_interval
var current_min_interval
var last_spawn_height
var screen_size



func _ready():
	randomize()
	
	last_spawn_height = get_viewport().get_viewport().size.y
	current_max_interval = MIN_INTERVAL
	current_min_interval = MIN_INTERVAL
	screen_size = get_viewport().get_visible_rect().size.x
	_spawn_first_platforms()


func _process(delta):
	score_text.text = str(player.score)
	
	if last_spawn_height > player.highest_reached_position - PLATFORM_GENERATION_OFFSET:
		while true:
			if last_spawn_height < player.highest_reached_position - PLATFORM_GENERATION_OFFSET:
				break
			_spawn_platforms()


func _spawn_first_platforms():
	for counter in range(INITIAL_PLATFORMS_COUNT):
		_spawn_platforms()


func _spawn_platforms():
	randomize()
	
	var new_platform
	
	if rand_range(0, 100) > 100 - SPECIAL_PLATFORM_CHANCE:
		new_platform = special_platforms[rand_range(0, special_platforms.size())].instance()
	else:
		new_platform = platforms[rand_range(0, platforms.size())].instance()
	add_child(new_platform)
	new_platform.position = Vector2(
		rand_range(
			0 + new_platform.sprite_half_width,
			screen_size - new_platform.sprite_half_width),
		last_spawn_height)
	
	last_spawn_height -= rand_range(current_min_interval, current_max_interval)
	
	current_min_interval += 5
	current_max_interval += 7.5
	current_min_interval = clamp(current_min_interval, MIN_INTERVAL, MAX_INTERVAL / 0.75)
	current_max_interval = clamp(current_max_interval, MIN_INTERVAL, MAX_INTERVAL)

