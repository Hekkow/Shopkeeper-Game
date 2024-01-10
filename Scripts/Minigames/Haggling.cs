using Godot;
using Godot.Collections;

public partial class Haggling : Control
{
	float speed = 10;
    float scoreMultiplierHit = 1.3f;
    float scoreMultiplierMissed = 1.2f;
	float scoreMultiplier = 1;
    float minDistance = 5;
	int numberBoxes = 6;
	float boxWidth = 20;
    float boxHeight;
    float pointerSize = 2;
	Vector2 pointerDirection = new(1, 0);
	Array<Area2D> boxes = new();
	ColorRect background;
	Character character;
	Area2D pointer;
	Color pointerColor = new(1, 0, 0);
	Color boxColor = new(0, 1, 0);
	Color backgroundColor = new(1, 1, 1);
	Color missedColor = new(1, 0, 0);
	double missedDuration = 0.05;
    public override void _Ready()
    {
		pointer = (Area2D)GetNode("Pointer");
		boxHeight = Size.Y;
		background = new();
		background.Size = Size;
		background.Color = backgroundColor;
		AddChild(background);
		for (int i = 0; i < numberBoxes; i++) boxes.Add(CreateArea(new Vector2(GetValidPosition(), 0), new Vector2(boxWidth, boxWidth), boxColor));
    }
	public void SetCustomer(Character character) {
		this.character = character;
	}
	int GetValidPosition()
	{
		bool found = false;
		int x = -1;
		while (!found)
		{
			x = Data.Instance.rng.RandiRange(0, (int)(Size.X - boxWidth));
			found = true;
			foreach (Area2D box in boxes)
			{
				float leftBoundary1 = box.Position.X;
				float leftBoundary2 = x;
				float rightBoundary1 = box.Position.X + boxWidth;
				float rightBoundary2 = x + boxWidth;
				if (rightBoundary1 >= leftBoundary2 && leftBoundary1 <= rightBoundary2)
				{
					found = false;
					break;
				}
				if (Mathf.Abs(leftBoundary1 - rightBoundary2) < minDistance)
				{
					found = false;
					break;
				}
				if (Mathf.Abs(rightBoundary1 -  leftBoundary2) < minDistance)
				{
					found = false;
					break;
				}
			}
		}
		return x;
	}
	Area2D CreateArea(Vector2 position, Vector2 size, Color color, int zindex = 0)
	{
		Area2D area = new();
		CollisionShape2D collision = new();
		RectangleShape2D shape = new();
		ColorRect colorRect = new();
		area.Position = position;
		area.ZIndex = zindex;
		shape.Size = size;
		collision.Shape = shape;
		collision.Position = size / 2;
		colorRect.Size = size;
		colorRect.Color = color;
		area.AddChild(collision);
		area.AddChild(colorRect);
		AddChild(area);
		return area;
	}
    public override void _Input(InputEvent e)
    {
        if (e is InputEventMouseButton && ((InputEventMouseButton)e).Pressed)
		{
			Array<Area2D> overlap = pointer.GetOverlappingAreas();
			if (overlap.Count == 0) Missed();
			else Hit(overlap[0]);
		}
    }
	void Hit(Area2D box)
	{
		box.QueueFree();
		scoreMultiplier *= scoreMultiplierHit;
	}
	async void Missed()
	{
		scoreMultiplier /= scoreMultiplierMissed;
		background.Color = missedColor;
		await ToSignal(GetTree().CreateTimer(missedDuration), "timeout");
        background.Color = backgroundColor;

    }
    public override void _Process(double delta)
    {
		pointer.Position += pointerDirection * speed;
		if (pointer.Position.X >= Size.X) pointerDirection *= -1;
		if (pointer.Position.X <= 0)
		{
			SignalManager.Instance.EmitSignal(SignalManager.SignalName.HagglingEnded, character, scoreMultiplier);
			QueueFree();
		}
    }
}