extends Control

var conversionArr = "ABCDEFGHIJKLMNNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+"
onready var bodySlider = self.get_child(0).get_child(1).get_child(0)
onready var attributeSliders = self.get_child(0).get_child(2)
onready var GunPartList = self.get_parent().get_child(0)
onready var weapon_mount = self.get_parent().get_child(1)

var all_clear = true
var serial = "A"
var weapon_parts

signal update_weapon(attribute, serial)

func _ready():
	bodySlider.max_value = GunPartList.Body.size() - 1

func _on_GunGenDemo2_broadcast_serial_no(serial_code):
	all_clear = false
	clear_sliders()
	if all_clear:
		var num
		var i
		serial = serial_code
		print(serial_code)
		bodySlider.value = decode(serial_code[0])
		weapon_parts = weapon_mount.get_child(0).get_child(0).get_children()
		#print(weapon_parts)
		i = 0
		for part in weapon_parts:
			i += 1
			if serial_code.length() > i:
				print(part.name, serial_code[i])
				num = serial_code[i]
			else:
				num = 0
			add_slider(part.name, decode(num), GunPartList.Parts.get(part.name).size() - 1)


func clear_sliders():
	for slider in attributeSliders.get_children():
			slider.queue_free()
	all_clear = true


func add_slider(text, val, max_val):
	var slider = load("res://scenes/AttributeSlider.tscn")
	var chil = slider.instance()
	chil.attribute = text
	chil.val = val
	chil.max_val = max_val
	attributeSliders.add_child(chil)
	

func decode(code):
	return conversionArr.find(code)

func encode(num):
	return conversionArr[num]

func _on_BodySlider_value_changed(value):
	#print(value)
	if value != decode(serial[0]):
		emit_signal("update_weapon", "Body", encode(value))

func _on_GunGenDemo2_clear():
	clear_sliders()
