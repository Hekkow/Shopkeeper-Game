using Godot;

public partial class Player : CharacterBody2D
{
	private Vector2 dir;
	const int speed = 300;
	AnimatedSprite2D animatedSprite;
	public override void _Ready()
	{
		animatedSprite = GetNode("AnimatedSprite2D") as AnimatedSprite2D;
	}

    public override void _PhysicsProcess(double delta)
    {
		Velocity = dir * speed;
		switch (Helper.Instance.CardinalDirection(dir)) {
			case Helper.Direction.UP:
				animatedSprite.Play("up");
				break;
			case Helper.Direction.DOWN:
				animatedSprite.Play("down");
				break;
			case Helper.Direction.LEFT:
				animatedSprite.Play("side");
				animatedSprite.FlipH = true;
				break;
			case Helper.Direction.RIGHT:
				animatedSprite.Play("side");
				animatedSprite.FlipH = false;
				break;
			case Helper.Direction.NONE:
				animatedSprite.Stop();
				break;
			default:
				animatedSprite.Stop();
				break;
		}
		MoveAndSlide();
    }
    public override void _UnhandledInput(InputEvent @event)
    {
        dir.X = Input.GetAxis("ui_left", "ui_right");
		dir.Y = Input.GetAxis("ui_up", "ui_down");
		dir = dir.Normalized();
    }
}
