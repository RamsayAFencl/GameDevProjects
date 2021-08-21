extends Spatial

var SPEED = 10

func _physics_process(delta):
	#print($CSGSphere2.get_transform().origin)
	#$CSGSphere4.translate($CSGSphere2.get_transform().origin)
	
	#control_upper_ball_point(delta)
	control_upper_ball_rotation(delta)
	control_lower_ball(delta)

func _process(delta):
	$CSGSphere/CSGBox/CSGSphere3/CSGBox2.rotate_object_local(Vector3.BACK, deg2rad(90)*delta)
	$CSGSphere/CSGBox.rotate_object_local(Vector3.FORWARD, deg2rad(90)*delta)
	
	$CSGSphere.look_at($Spatial2/CSGSphere2.global_transform.origin, Vector3.UP)
	$CSGSphere/CSGBox/CSGSphere3.look_at($CSGSphere4.get_transform().origin, Vector3.UP)
	print($Spatial2/CSGSphere2.global_transform.basis.get_euler())

func control_upper_ball_rotation(delta):
	if Input.is_action_pressed("move_left"):
		$Spatial2.rotate_object_local(Vector3.FORWARD, deg2rad(90)*delta)
	if Input.is_action_pressed("move_right"):
		$Spatial2.rotate_object_local(Vector3.BACK, deg2rad(90)*delta)
	if Input.is_action_pressed("move_up"):
		$Spatial2.rotate_object_local(Vector3.RIGHT, deg2rad(90)*delta)
	if Input.is_action_pressed("move_down"):
		$Spatial2.rotate_object_local(Vector3.LEFT, deg2rad(90)*delta)
	#print($Spatial2.transform)

func control_upper_ball_point(delta):
	if Input.is_action_pressed("move_up"):
		$Spatial2/CSGSphere2.translate(Vector3.FORWARD * delta * SPEED)
	if Input.is_action_pressed("move_down"):
		$Spatial2/CSGSphere2.translate(Vector3.FORWARD * -delta * SPEED)
	if Input.is_action_pressed("move_right"):
		$Spatial2/CSGSphere2.translate(Vector3.RIGHT * delta * SPEED)
	if Input.is_action_pressed("move_left"):
		$Spatial2/CSGSphere2.translate(Vector3.RIGHT * -delta * SPEED)

func control_lower_ball(delta):
	if Input.is_action_pressed("ui_up"):
		$CSGSphere4.translate(Vector3.FORWARD * delta * SPEED)
	if Input.is_action_pressed("ui_down"):
		$CSGSphere4.translate(Vector3.FORWARD * -delta * SPEED)
	if Input.is_action_pressed("ui_right"):
		$CSGSphere4.translate(Vector3.RIGHT * delta * SPEED)
	if Input.is_action_pressed("ui_left"):
		$CSGSphere4.translate(Vector3.RIGHT * -delta * SPEED)
