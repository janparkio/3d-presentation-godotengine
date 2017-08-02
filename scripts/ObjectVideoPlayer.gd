extends Quad

var stream = preload("res://videos/video_1.ogv")
onready var player = VideoPlayer.new()

func _ready():
    player = VideoPlayer.new()
    player.set_stream(stream)
    add_child(player)
    var texture = player.get_video_texture()
    var material = FixedMaterial.new()
    material.set_fixed_flag(FixedMaterial.FLAG_USE_ALPHA, true)
    material.set_texture(FixedMaterial.PARAM_DIFFUSE, texture)
    material.set_parameter(0, Color(1,1,1,0.5))
    material.set_flag(Material.FLAG_UNSHADED, true)
    set_material_override(material)
    # mute video player
    player.set_volume_db(-80)
    # play the video
    player.play()
    # start loop process
    set_process(true)

func _process(delta):
	if not player.is_playing():
		player.play()