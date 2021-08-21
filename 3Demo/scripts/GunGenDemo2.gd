extends Spatial

var conversionArr = "ABCDEFGHIJKLMNNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+"
var last_gun_serialnum = "A"
var spawning = false
var time = 0.0

signal broadcast_serial_no(serial)
signal clear()

export(NodePath) onready var node = get_node(node)
export(int, "Rigid", "Static", "Character", "Kinematic") var physics_state = 0
#export(float, 0.0, 1.0, 0.1) var timeout = 0.5

#func _process(delta):
#	time += delta
#	if time >= timeout:
#		time =0
#		spawning = false

func _input(_event):
	if not spawning:
		if Input.is_action_just_pressed("jump"):
			spawning = true
			generate_serial()
			spawn_gun_from_serial(last_gun_serialnum)
		if Input.is_action_just_pressed("ui_up"):
			spawning = true
			spawn_gun_from_serial(last_gun_serialnum)
	if Input.is_action_just_pressed("ui_down"):
		clear_guns()

func clear_guns():
	for child in node.get_children():
			child.queue_free()
	spawning = false
	emit_signal("clear")

func generate_serial():
	clear_guns()
	var serialnum = ""
	var rand = randi()%$GunPartList.Body.size()
	serialnum += encode(rand)
	var part = load($GunPartList.Body[rand])
	var chil = part.instance()
	for i in chil.get_child(0).get_children():
		if $GunPartList.Parts.has(i.name):
			rand = randi()%$GunPartList.Parts.get(i.name).size()
			serialnum += encode(rand)
	last_gun_serialnum = serialnum
#	chil.set_mode(physics_state)
#	node.add_child(chil)
#	var newGun = node.get_child(node.get_child_count()-1)
#	for i in newGun.get_child(0).get_children():
#		if $GunPartList.Parts.has(i.name):
#			rand = randi()%$GunPartList.Parts.get(i.name).size()
#			serialnum += encode(rand)
#			part = load($GunPartList.Parts.get(i.name)[rand])
#			chil = part.instance()
#			i.add_child(chil)
#	last_gun_serialnum = serialnum
#	print(serialnum)
#	emit_signal("broadcast_serial_no", serialnum)

func spawn_gun_from_serial(serialnum):
	clear_guns()
	var i = 0
	var num = decode(serialnum[i])
	var part = load($GunPartList.Body[num])
	var chil = part.instance()
	chil.set_mode(physics_state)
	node.add_child(chil)
	var newGun = node.get_child(node.get_child_count()-1)
	for attachment in newGun.get_child(0).get_children():
		if $GunPartList.Parts.has(attachment.name):
			i += 1
			if i < serialnum.length():
				num = decode(serialnum[i])
				part = load($GunPartList.Parts.get(attachment.name)[num])
				chil = part.instance()
				attachment.add_child(chil)
	emit_signal("broadcast_serial_no", serialnum)

func decode(code):
	return conversionArr.find(code)

func encode(num):
	return conversionArr[num]

func _on_Control_update_weapon(attribute, serial):
	clear_guns()
	var i = 0 
	var num = decode(serial[i])
	var part = load($GunPartList.Parts.get(attribute)[num])
	var chil = part.instance()
	chil.set_mode(physics_state)
	node.add_child(chil)
	print(serial)
	emit_signal("broadcast_serial_no", serial)
