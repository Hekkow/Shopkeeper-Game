using Godot;

public partial class DisplayCase : Node {
	[Export] public Item item = null;
    [Export] public Vector2I coordinates;
    public DisplayCase(Vector2I coordinates)
    {
        this.coordinates = coordinates;
        SignalManager.Instance.CustomerInterested += OnCustomerInterested;
    }
    void OnCustomerInterested(Character character, Item item)
    {
        if (this.item is not null && this.item == item)
        {
            this.item = null;
        }
    }
    public override string ToString()
    {
        if (item is null) { return coordinates.ToString() + " is null"; }
        return coordinates.ToString() + " " + item.ToString();
    }
}