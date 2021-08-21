extends Light

var t = 0

func _process(delta):
	t += delta
	if t > 3.5:
		self.light_energy = rand_range(0.5, 1.2)
	else:
		self.light_energy = 1
	if t > rand_range(5, 10):
		t = 0
