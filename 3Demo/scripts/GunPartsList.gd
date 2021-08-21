extends Node

var Barrel = []
var Body = []
var BottomAttachment = []
var Cylinder = []
var Grip = []
var LeftAttachment = []
var Mag = []
var Sight = []
var Stock = []

var Parts = {
	Barrel = Barrel,
	Body = Body,
	BottomAttachment = BottomAttachment,
	Cylinder = Cylinder,
	Grip = Grip,
	LeftAttachment = LeftAttachment,
	Mag = Mag,
	Sight = Sight,
	Stock = Stock
}

var directory

func _init():
	dir_contents("res://weapon_parts/")
	print("\n")
	print(Parts)

func dir_contents(path):
	var dir = Directory.new()
	if dir.open(path) == OK:
		dir.list_dir_begin(true)
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				print("Found directory: " + file_name)
				directory = file_name
				dir_contents(path+file_name)
			else:
				print("\tFound file: " + file_name)
				print(Parts.has(directory), directory)
				if Parts.has(directory):
					Parts.get(directory).append(path+"/"+file_name)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
