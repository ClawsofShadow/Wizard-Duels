extends Camera2D


@onready var p1  = get_parent().get_node("FOX")

func _ready():
	pass

func _physics_process(delta):
	self.position = p1.position
