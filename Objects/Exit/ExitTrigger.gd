extends Exit

func _ready():
	body_entered.connect(on_stepped_on)
	super()

func on_stepped_on(body):
	if body is Player:
		triggered()	
		