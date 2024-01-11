using Godot;
using Godot.Collections;

public partial class PlayerDetectionArea : Area2D
{
	Array<Area2D> areas = new();
    public override void _Ready()
    {
		AreaEntered += OnAreaEntered;
		AreaExited += OnAreaExited;
    }
	void OnAreaEntered(Area2D area)
	{
		if (area is not Interactable) return;
        Panel buttonPrompt = (Panel)GD.Load<PackedScene>("res://Scenes/UI/ButtonPrompt.tscn").Instantiate();
		buttonPrompt.Name = "ButtonPrompt";
		area.AddChild(buttonPrompt);
		buttonPrompt.Position = new Vector2(25, -50);
		areas.Add(area);

    }
    void OnAreaExited(Area2D area)
	{
		int index = areas.IndexOf(area);
		if (index == -1) return;
		Panel buttonPrompt = (Panel)area.GetNodeOrNull("ButtonPrompt");
		if (buttonPrompt is not null) buttonPrompt.QueueFree();
		areas.RemoveAt(index);
	}
    public override void _Input(InputEvent e)
    {
        if (e.IsActionPressed("interact"))
		{
			if (areas[0] is not Interactable) return;
			((Interactable)areas[0]).Interact();
			areas[0].GetNode("ButtonPrompt").QueueFree();
        }
    }
}