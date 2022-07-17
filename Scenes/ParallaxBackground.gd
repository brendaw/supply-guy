extends ParallaxBackground

var scroll_velocity = Vector2(25, 0)

var scroll


func _ready():
	enable_scroll()


func _process(delta):
	if (scroll):
		var new_offset = get_scroll_offset() + scroll_velocity * delta
		set_scroll_offset(new_offset)


func enable_scroll():
	scroll = true


func disable_scroll():
	scroll = false
