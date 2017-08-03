#title           :MoveCamera.gd
#description     :This scripts moves a kinematic body by the name of "MoveCamera"
#				  modifies the image slides and videos dynamically and in an orderly manner.
#author		 	 :JanPark
#version         :1.0

extends KinematicBody

onready var TweenNode = get_node("Tween")
onready var SlideNode = get_node("../Slide2")
onready var SlideVideo = get_node("SlideVideo")

onready var MovingNode = SlideNode

var is_fullscreen = false
# general slide order num
var slide_order_num = 1

var slide_video_num = 1
# modify this variable if you have a different video presenation name
export var slide_video_name = "res://videos/video_"
# currently there is no other support for videos other than ogv
# which means you would not be modifying this anytime soon (02.08.2017 - Jan Park)
export var slide_video_ext = ".ogv"
var slide_video_current_name = ""
# also modify the maximum number of video slides
const MAX_SLIDE_VIDEO_NUM = 1
var slide_video_on = false

var slide_file_num = 1
# modify this variable if you have a different presenation name
export var slide_file_name = "res://presentations/basic_presentation_"
# do not forget the extension of the files
export var slide_file_ext = ".jpg"
var slide_file_current_name = ""
# also modify the maximum number of image slides
const MAX_SLIDE_FILE_NUM = 9

var slide_node_pressed = false
var slide_node_on = false
var slide_node_num = 1
var slide_node_name = "../Slide"
var slide_node_current_name = ""
const MAX_SLIDE_NODE_NUM = 4

# the maximum number slide is the sum of all other nums
const MAX_SLIDE_ORDER_NUM = MAX_SLIDE_VIDEO_NUM + MAX_SLIDE_FILE_NUM

func _ready():
	set_process_input(true)
	set_process(true)

func _process(delta):
	#position.x = Input.is_action_pressed("ui_right") - Input.is_action_pressed("ui_left")
	#position.y = Input.is_action_pressed("ui_up") - Input.is_action_pressed("ui_down")
	#velocity = position * speed * delta
	if Input.is_action_pressed("ui_fullscreen"):
		is_fullscreen = !is_fullscreen
		OS.set_window_fullscreen(is_fullscreen)
	if Input.is_action_pressed("ui_exit"):
		get_tree().quit()
	
	if Input.is_action_pressed("ui_left"):
		slide_file_num -= 1
		if slide_file_num <= 0:
			slide_file_num = 1
		
		slide_order_num -= 1
		if slide_order_num <= 0:
			slide_order_num = 1
		move_slide()

	#translate(velocity)
	if slide_node_pressed and not slide_node_on or Input.is_action_pressed("ui_right"):
		# count the general order slide
		if slide_order_num >= MAX_SLIDE_ORDER_NUM:
			slide_order_num = 1
		elif slide_order_num < MAX_SLIDE_ORDER_NUM:
			slide_order_num += 1

		# check if we are not currently reproducing a video
		if not slide_video_on:
			if slide_node_num >= MAX_SLIDE_NODE_NUM and not slide_node_on:
				slide_node_num = 1
				slide_node_on = true
			elif slide_node_num < MAX_SLIDE_NODE_NUM and not slide_node_on:
				slide_node_num += 1
				slide_node_on = true
			
			if slide_file_num >= MAX_SLIDE_FILE_NUM:
				slide_file_num = 1
			elif slide_file_num < MAX_SLIDE_FILE_NUM:
				slide_file_num += 1
		
		# if we are count video and move on
		elif slide_video_on:
			if slide_video_num >= MAX_SLIDE_VIDEO_NUM:
				slide_video_num = 1
			elif slide_video_num < MAX_SLIDE_VIDEO_NUM:
				slide_video_num += 1
			slide_video_on = false

		# move slide on every click
		move_slide()

func _input(event):
	if event.is_action_pressed("ui_left_click"):
		slide_node_pressed = true

	elif event.is_action_released("ui_left_click"):
		slide_node_pressed = false
		slide_node_on = false

### main function that controls movement
func move_slide():
	# comment or add more condision if you are using videos on your slides.
	# eliminate the else statement if you are just using images
	if (slide_order_num == 3 and not slide_video_on):
		play_video_slide()
	else:
	# do not comment out the following code
		play_image_slide()

func play_image_slide():
	slide_node_current_name = slide_node_name + str(slide_node_num)
	SlideNode = get_node(slide_node_current_name)
	# set slide node
	MovingNode = SlideNode
	# set material override texture path to the new file
	slide_file_current_name = slide_file_name + str(slide_file_num) + slide_file_ext
	var mat_ = MovingNode.get_material_override()
	mat_.set_parameter(0, Color(1,1,1,1))
	mat_.set_texture( 0, load(slide_file_current_name) )
	
	TweenNode.interpolate_property(self, "transform/translation", get_translation(), MovingNode.get_translation(), 2.5, Tween.TRANS_BACK, Tween.EASE_OUT)
	TweenNode.interpolate_property(self, "transform/rotation", get_rotation_deg(), MovingNode.get_rotation_deg(), 1.5, Tween.TRANS_BACK, Tween.EASE_OUT)
	TweenNode.start()

func play_video_slide():
	slide_node_num = 1
	slide_node_current_name = slide_node_name + str(slide_node_num)
	SlideNode = get_node(slide_node_current_name)
	
	MovingNode = SlideNode
	var texture = MovingNode.get_material_override().get_texture(0)
	var material = FixedMaterial.new()
	material.set_fixed_flag(FixedMaterial.FLAG_USE_ALPHA, true)
	material.set_texture(FixedMaterial.PARAM_DIFFUSE, texture)
	material.set_parameter(0, Color(1,1,1,0))
	material.set_flag(Material.FLAG_UNSHADED, true)
	MovingNode.set_material_override(material)
	
	TweenNode.interpolate_property(self, "transform/translation", get_translation(), MovingNode.get_translation(), 2.5, Tween.TRANS_BACK, Tween.EASE_OUT)
	TweenNode.interpolate_property(self, "transform/rotation", get_rotation_deg(), MovingNode.get_rotation_deg(), 1.5, Tween.TRANS_BACK, Tween.EASE_OUT)
	TweenNode.start()
	
	slide_node_num += 1
	MovingNode = SlideVideo
	
	slide_video_current_name = slide_video_name + str(slide_video_num) + slide_video_ext
	#print(slide_video_current_name)
	MovingNode.set_new_stream(slide_video_current_name)
	MovingNode.initialize()
	slide_video_on = true