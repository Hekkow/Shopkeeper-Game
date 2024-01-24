extends AnimatedSprite2D


func walk_animation(dir):
	match Helper.cardinal_direction(dir):
		Helper.Direction.UP:
			play("up")
		Helper.Direction.DOWN:
			play("down")
		Helper.Direction.LEFT:
			play("side")
			flip_h = true
		Helper.Direction.RIGHT:
			play("side")
			flip_h = false
		Helper.Direction.NONE:
			stop()

func stop_animation():
	stop()
