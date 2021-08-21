extends KinematicBody

var SPEED = 5
export var GRAVITY = 9.8
var garr = [Vector3(0.0,1.0,0.0), Vector3(0.0,0.0,-1.0), Vector3(0.0,0.0,1.0), Vector3(1.0,0.0,0.0)]
var i = 0
var dir : Vector3 = Vector3.ZERO
var v : Vector3 = Vector3.ZERO
var hangtime = 1

var dirForward : Vector3 = Vector3.ZERO
var dirBase : Vector3 = Vector3.ZERO
var avgNormal : Vector3 = Vector3.UP
var fowardDir : Vector3 = Vector3.BACK

var arr : Array

func _physics_process(delta):
	change_SPEED()
	rotate_camera(delta)
	if Input.is_action_just_pressed("jump"):
		v = avgNormal * 50
		#i = (i + 1) % garr.size()
	else:
		v = movement(delta) + apply_gravity(delta)
	v = move_and_slide(v, avgNormal.normalized(), true, 4, deg2rad(45), false)

func movement(delta):
	dir = Vector3.ZERO
	fowardDir = ( $CameraAxis/SpringArm/CameraMount/Camera/Position3D.global_transform.origin - $CameraAxis/SpringArm/CameraMount/Camera.global_transform.origin  ).normalized()
	print(fowardDir, " || ", Vector3.BACK)
	dirBase = avgNormal.cross(fowardDir).normalized()#Vector3.BACK).normalized()
	if dirBase == Vector3.ZERO: 
		dirBase = avgNormal.cross( Vector3.UP).normalized()
	
	dirForward = dirBase.rotated( avgNormal.normalized(), -PI/2 )
	
	dir += (Input.get_action_strength("move_up") - Input.get_action_strength("move_down")) * dirForward
	dir += (Input.get_action_strength("move_left") - Input.get_action_strength("move_right")) * dirBase
	match avgNormal:
		#Vector3(0.0,0.0,1.0):
		#	rotate_ball(delta, -1)
		#	return dir.normalized() * -SPEED
		_:
			rotate_ball(delta, 1)
			return dir.normalized() * SPEED

func rotate_camera(delta):
	$CameraAxis/SpringArm.rotate_y(delta*(Input.get_action_strength("ui_left") - Input.get_action_strength("ui_right"))) 

func rotate_ball(delta, x_sign):
	$Gravitydirection.look_at(get_transform().origin - dirBase, avgNormal)
	$Spatial.look_at(get_transform().origin - dirBase, avgNormal)
	$CameraAxis.look_at(get_transform().origin - dirBase, avgNormal)
	#$CameraAxis.rotation.x = lerp_angle($CameraAxis.rotation.x, avgNormal.x, 0.1)
	#$CameraAxis.rotation.z = lerp_angle($CameraAxis.rotation.z, avgNormal.z, 0.1)
	#$CameraAxis.look_at(get_transform().origin - dirBase, avgNormal)
	$Spatial/CSGSphere.rotate_x(PI * delta * SPEED * dir.dot(dirBase) * x_sign)
	$Spatial/CSGSphere.rotate_z(PI * delta * SPEED * dir.dot(dirForward))


func apply_gravity(delta):
	var avgNor := Vector3.ZERO
	var numOfRaysColliding := 0
	for ray in $Spatial/rays.get_children():
		var r : RayCast = ray
		if r.is_colliding():
			numOfRaysColliding += 1
			avgNor += r.get_collision_normal()
	if avgNor:
		hangtime = 1
		avgNor /= numOfRaysColliding
		#var angle = avgNormal.angle_to(avgNor)
		if not listy_boi(avgNor):#not listy_boi(avgNor.normalized()):
			avgNormal = avgNor.normalized() 
		return avgNormal * -1 * GRAVITY/4
	else:
		avgNormal = garr[i] * hangtime
		hangtime += delta
		arr.clear()
		return avgNormal * -1 *GRAVITY

func listy_boi(num):
	if arr.size() >= 3:
			arr.clear()
	#print(arr)
	if not arr.has(num):
		arr.push_front(num)
		return false
	else:
		return true

func change_SPEED():
	if Input.is_action_just_pressed("ui_up"):
		SPEED = clamp(SPEED+1, 0 , 10)
	if Input.is_action_just_pressed("ui_down"):
		SPEED = clamp(SPEED-1, 0 , 10)
