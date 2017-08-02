extends Quad

export var stream = preload("res://videos/video_1.ogv")
onready var player = VideoPlayer.new()

onready var TweenNode = get_node("Tween")
onready var Anker1 = get_node("../SlideVideoAnker1")
onready var Anker2 = get_node("../SlideVideoAnker2")
onready var Anker3 = get_node("../SlideVideoAnker3")
onready var Anker4 = get_node("../SlideVideoAnker4")

var transition_num = 0
const MAX_TRAN_NUM = 3
var wait_time = 1
var count_wait_time = 0

func _ready():
	# start loop process
	count_wait_time = 0
	set_process(true)
	# start loop process
	#set_process(true)
	# initialized pos
	#move_tween_transition(Anker4.get_translation(), 3, Anker4.get_rotation_deg(), 1.5)
	pass

func initialize():
	# initialized pos
	count_wait_time = 0.1
	move_tween_transition(Anker4.get_translation(), 1, Anker4.get_rotation_deg(), 1.5)

func _process(delta):
	if count_wait_time < wait_time and count_wait_time != 0:
		count_wait_time += delta
		#print(count_wait_time)
	elif count_wait_time >= wait_time:
		if transition_num == 0:
			move_tween_transition(Anker1.get_translation(), 2, Anker1.get_rotation_deg(), 1.5)
			set_transition_order(2.1, transition_num + 1, 0.1)
			pass
		elif transition_num == 1:
			move_tween_transition_ease(Anker2.get_translation(), 1.1, Anker2.get_rotation_deg(), 0.8)
			set_transition_order(1.2, transition_num + 1, 0.1)
			pass
		elif transition_num == 2:
			# play the video
			set_video_player(true)
			set_transition_order(0, transition_num + 1, 0)
			pass
		elif Input.is_action_pressed("ui_left_click") and transition_num == 3:
			move_tween_transition(Anker3.get_translation(), 1, Anker3.get_rotation_deg(), 1.5)
			player.stop()
			set_transition_order(1, transition_num + 1, 0.1)
			pass
		elif (transition_num == 4) or (Input.is_action_pressed("ui_left_click") and not transition_num == 3):
			move_tween_transition(Anker4.get_translation(), 1.2, Anker4.get_rotation_deg(), 1.5)
			set_transition_order(1, 0, 0)
			pass

func move_tween_transition(pos, pos_time, rotation, rotation_time):
	TweenNode.interpolate_property(self, "transform/translation", get_translation(), pos, pos_time, Tween.TRANS_BACK, Tween.EASE_OUT)
	TweenNode.interpolate_property(self, "transform/rotation", get_rotation_deg(), rotation, rotation_time, Tween.TRANS_BACK, Tween.EASE_OUT)
	TweenNode.start()

func move_tween_transition_ease(pos, pos_time, rotation, rotation_time):
	TweenNode.interpolate_property(self, "transform/translation", get_translation(), pos, pos_time, Tween.TRANS_LINEAR, Tween.EASE_IN)
	TweenNode.interpolate_property(self, "transform/rotation", get_rotation_deg(), rotation, rotation_time, Tween.TRANS_BACK, Tween.EASE_IN)
	TweenNode.start()

func set_transition_order(_wait_time, _transition_num, _count_wait_time = 0.1):
	wait_time = _wait_time
	# current transition number
	transition_num = _transition_num
	# the time where the counter starts
	count_wait_time = _count_wait_time

func set_video_player(set_play = true):
	player = VideoPlayer.new()
	player.set_stream(stream)
	add_child(player)
	var texture = player.get_video_texture()
	var material = FixedMaterial.new()
	material.set_fixed_flag(FixedMaterial.FLAG_USE_ALPHA, true)
	material.set_texture(FixedMaterial.PARAM_DIFFUSE, texture)
	material.set_flag(Material.FLAG_UNSHADED, true)
	set_material_override(material)
	# play the video
	if set_play:
		player.play()

func set_new_stream(_stream):
	stream = load(_stream)