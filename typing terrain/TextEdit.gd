extends TextEdit


func _process(delta):

	if Input.is_action_just_released("ui_accept"):
		get_parent().get_parent().get_node("MeshInstance").set_uniform_com_txt(text)
		
