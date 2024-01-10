using Godot;

public partial class Data : Node {
    public static Data Instance;
    public override void _Ready()
    {
        Instance = this;
    }
    public Store store;
	public RandomNumberGenerator rng = new();
}