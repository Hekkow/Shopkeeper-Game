using Godot;
using System.IO;
using System;

public partial class Minigames : CanvasLayer
{
    Vector2 hagglingPosition = new(267, 72);
    public override void _Ready()
    {
		SignalManager.Instance.HagglingStarted += OpenHaggling;
    }
	void OpenHaggling(Character character)
	{

		Haggling haggling = (Haggling)GD.Load<PackedScene>("res://Scenes/Minigames/Haggling.tscn").Instantiate();
		haggling.Position = hagglingPosition;
		haggling.ZIndex = 10;
		AddChild(haggling);
		haggling.SetCustomer(character);
	}
    public override void _ExitTree()
    {
        SignalManager.Instance.HagglingStarted -= OpenHaggling;
    }

}