using Godot;

public partial class RecipeToItemPanel : Panel
{
	bool priceModal = false;
    public override void _Ready()
    {
		SignalManager.Instance.RecipePressed += CanClick;
		SignalManager.Instance.PriceSet += CanNotClick;
		SignalManager.Instance.ItemPlaced += CanClick;
		SignalManager.Instance.PriceModalSpawned += OnPriceModalSpawned;
		SignalManager.Instance.PriceModalDespawned += OnPriceModalDespawned;
        SignalManager.Instance.ItemPlacementCancelled += CanClick;
    }
    public override void _ExitTree()
    {
        SignalManager.Instance.RecipePressed -= CanClick;
        SignalManager.Instance.PriceSet -= CanNotClick;
        SignalManager.Instance.ItemPlaced -= CanClick;
        SignalManager.Instance.PriceModalSpawned -= OnPriceModalSpawned;
        SignalManager.Instance.PriceModalDespawned -= OnPriceModalDespawned;
        SignalManager.Instance.ItemPlacementCancelled -= CanClick;
    }
    void OnPriceModalSpawned(Recipe recipe)
	{
		priceModal = true;
	}
    void OnPriceModalDespawned()
    {
        priceModal = false;
    }
    public override void _GuiInput(InputEvent @event)
    {
        if (@event is InputEventMouseButton && ((InputEventMouseButton)@event).IsPressed())
        {
            Escape();
        }
    }
    public override void _Input(InputEvent @event)
    {
        if (@event.IsActionPressed("ui_cancel"))
        {
            Escape();
        }
    }
    void Escape()
	{
		if (priceModal) SignalManager.Instance.EmitSignal(SignalManager.SignalName.EscapeRecipeToItemPriceModal);
		else SignalManager.Instance.EmitSignal(SignalManager.SignalName.EscapeRecipeToItem);
    }
	void CanClick(Recipe recipe)
	{
		MouseFilter = Control.MouseFilterEnum.Stop;
	}
    void CanClick(DisplayCase displayCase, Item item)
    {
        MouseFilter = Control.MouseFilterEnum.Stop;
    }
    void CanClick(Item item)
    {
        MouseFilter = Control.MouseFilterEnum.Stop;
    }
    void CanNotClick(Item item)
	{
        MouseFilter = Control.MouseFilterEnum.Ignore;

    }
}