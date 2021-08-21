extends Spatial

var conversionArr = "ABCDEFGHIJKLMNNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+"
var last_gun_serialnum = "AAAAAAAA"
var spawning = false
var time = 0.0

func _process(delta):
	time += delta
	if time >= .5:
		time =0
		spawning = false

func _input(_event):
	if not spawning:
		if Input.is_action_just_pressed("jump"):
			spawning = true
			spawn_new_gun()
		if Input.is_action_just_pressed("ui_up"):
			spawning = true
			spawn_gun_from_serial(last_gun_serialnum)
	if Input.is_action_just_pressed("ui_down"):
		for child in $Position3D.get_children():
			child.queue_free()

func spawn_new_gun():
	var serialnum = ""#"Body:"
	var rand = randi()%$GunPartList.Body.size()
	serialnum += encode(rand)
	var part = load($GunPartList.Body[rand])
	var chil = part.instance()
	$Position3D.add_child(chil)
	var newGun = $Position3D.get_child($Position3D.get_child_count()-1)
	for i in newGun.get_child(0).get_children():
		if $GunPartList.Parts.has(i.name):
			rand = randi()%$GunPartList.Parts.get(i.name).size()
			#serialnum += "|" + i.name + ":"
			serialnum += encode(rand)
			part = load($GunPartList.Parts.get(i.name)[rand])
			chil = part.instance()
			i.add_child(chil)
	last_gun_serialnum = serialnum
	#print(serialnum)

func spawn_gun_from_serial(serialnum):
	var i = 0
	var temp = ""
	var num = decode(serialnum[i])
	temp += str(num)
	var part = load($GunPartList.Body[num])
	var chil = part.instance()
	$Position3D.add_child(chil)
	var newGun = $Position3D.get_child($Position3D.get_child_count()-1)
	for attachment in newGun.get_child(0).get_children():
		if $GunPartList.Parts.has(attachment.name):
			i += 1
			num = decode(serialnum[i])
			part = load($GunPartList.Parts.get(attachment.name)[num])
			chil = part.instance()
			attachment.add_child(chil)
			temp += str(num)
	#print(temp)

func decode(code):
	return conversionArr.find(code)

func encode(num):
	return conversionArr[num]
