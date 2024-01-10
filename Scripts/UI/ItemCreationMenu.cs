using Godot;
public partial class ItemCreationMenu : Control
{
    public override void _Ready()
    {
		SignalManager.Instance.StoreOpened += CloseMenu;
        SignalManager.Instance.EscapeRecipeToItem += CloseMenu;
        SignalManager.Instance.PriceSet += IsNoVisible;
		SignalManager.Instance.ItemPlaced += IsYesVisible;
		SignalManager.Instance.ItemPlacementCancelled += IsYesVisible;
    }
    public override void _ExitTree()
    {
        SignalManager.Instance.StoreOpened -= CloseMenu;
        SignalManager.Instance.EscapeRecipeToItem -= CloseMenu;
        SignalManager.Instance.PriceSet -= IsNoVisible;
        SignalManager.Instance.ItemPlaced -= IsYesVisible;
        SignalManager.Instance.ItemPlacementCancelled -= IsYesVisible;
    }
    void CloseMenu()
	{
		QueueFree();
	}
	void IsNoVisible(Item item)
	{
		Visible = false;
	}
    void IsYesVisible(Item item)
    {
        Visible = true;
    }
    void IsYesVisible(DisplayCase displayCase, Item item)
	{
		Visible = true;
	}

}