extends KinematicBody

export(NodePath) var animationtree
export(NodePath) onready var camera = get_node(camera)

onready var _anim_tree = get_node(animationtree)

var gravity = Vector3.ZERO
onready var groundcheck = self.get_node("GroundCheck")
var grounded

func _physics_process(delta):
	var root_motion : Transform = _anim_tree.get_root_motion_transform()
	
	var v = root_motion.origin / delta
	if groundcheck.is_colliding(): #is_on_floor():
		grounded = true
		gravity = Vector3.ZERO
	else:
		grounded = false
		gravity += Vector3(0.0, -9.8*delta, 0.0)	
	v += gravity
	
	var dir : Vector3 = Vector3.ZERO
	
	if Input.is_action_pressed("move_up"):
		dir.z += 1.0
	if Input.is_action_pressed("move_down"):
		dir.z -= 1.0
	if Input.is_action_pressed("move_left"):
		dir.x += 1.0
	if Input.is_action_pressed("move_right"):
		dir.x -= 1.0
	
	if dir.length_squared() > 0.01:
		dir = dir.rotated(Vector3.UP, camera.setup.rotation.y)
		
		var player_heading_2d := Vector2(self.transform.basis.z.x, self.transform.basis.z.z)
		var desired_heading_2d := Vector2(dir.x, dir.z)
		
		var phi : float = desired_heading_2d.angle_to(player_heading_2d)
		phi = phi * delta * 3.0
		self.rotation.y += phi
		v = v.rotated(Vector3.UP, self.rotation.y)
		if Input.is_action_pressed("sprint"):
			_anim_tree["parameters/playback"].travel("running")
		else:
			_anim_tree["parameters/playback"].travel("walking")
	else:
		_anim_tree["parameters/playback"].travel("idle")
		v = v.rotated(Vector3.UP, self.rotation.y)
	if grounded && Input.is_action_just_pressed("jump"):
		_anim_tree["parameters/conditions/jump"] = true
		v -= Vector3(0.0, -100.0, 0.0)
	else:
		_anim_tree["parameters/conditions/jump"] = false
	_anim_tree["parameters/conditions/grounded"] = grounded
	
	move_and_slide(v, Vector3.UP)
