extends Camera

export(NodePath) onready var target = get_node(target)

func _process(delta):
	look_at(target.translation, Vector3(0.0,1.0,0.0))
