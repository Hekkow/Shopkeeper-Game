using Godot;

public partial class PriceModal : CenterContainer
{
    public override void _Ready()
    {
		SignalManager.Instance.RecipePressed += DeleteThis;
		SignalManager.Instance.PriceSet += DeleteThis;
		SignalManager.Instance.EscapeRecipeToItemPriceModal += DeleteThis;
		SignalManager.Instance.StoreOpened += DeleteThis;
    }
    public override void _ExitTree()
    {
        SignalManager.Instance.EmitSignal(SignalManager.SignalName.PriceModalDespawned);
        SignalManager.Instance.RecipePressed -= DeleteThis;
        SignalManager.Instance.PriceSet -= DeleteThis;
        SignalManager.Instance.EscapeRecipeToItemPriceModal -= DeleteThis;
        SignalManager.Instance.StoreOpened -= DeleteThis;
    }
    void DeleteThis(Recipe recipe = null)
	{
		QueueFree();
	}
    void DeleteThis(Item item)
    {
        QueueFree();
    }
    void DeleteThis()
    {
        QueueFree();
    }
}