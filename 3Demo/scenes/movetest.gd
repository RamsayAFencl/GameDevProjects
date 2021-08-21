extends CSGBox

var tween
var array = [Vector3(2, 1, 2),Vector3(-2, 1, -2)]
var i = 0

func _ready():
	tween = Tween.new()
	add_child(tween)
	tween.interpolate_property($".", "translation", self.translation, array[i], 2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.connect("tween_all_completed", self, "_tween_all_completed")
	tween.start()

func _tween_all_completed():
	if i == 0:
		i = 1
	else:
		i = 0
	tween.interpolate_property($".", "translation", self.translation, array[i], 2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
