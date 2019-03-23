extends Label

func _process(delta):
	if delta != 0:
		set_text("FPS: " + str(int(1/delta)+1) + "\nNodes: " + str(get_parent().get_children().size()))