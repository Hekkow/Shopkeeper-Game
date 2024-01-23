extends Exit

func _ready():
	body_entered.connect(on_stepped_on)

func on_stepped_on(body):
	if body is Player:
		triggered()	
		