extends Spatial


func _physics_process(delta):
	$".".rotate_y(delta*(Input.get_action_strength("move_right") - Input.get_action_strength("move_left")))
	$CameraBoom.spring_length -= delta*(Input.get_action_strength("move_up") - Input.get_action_strength("move_down"))
	if $CameraBoom.spring_length < 0.5:
		$CameraBoom.spring_length = 0.5
