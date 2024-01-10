using Godot;
public partial class PriceInput : LineEdit
{
	Recipe recipe;
    public override void _Ready()
    {
		SignalManager.Instance.PriceModalSpawned += SetRecipe;
		TextSubmitted += OnPriceEnter;
		GrabFocus();
    }
    public override void _ExitTree()
    {
        SignalManager.Instance.PriceModalSpawned -= SetRecipe;
    }
    void SetRecipe(Recipe recipe)
	{
		this.recipe = recipe;
	}
	void OnPriceEnter(string price)
	{
		if (price == "") SignalManager.Instance.EmitSignal(SignalManager.SignalName.PriceSet, new Item(recipe));
		else
		{
			if (price.IsValidInt()) SignalManager.Instance.EmitSignal(SignalManager.SignalName.PriceSet, new Item(recipe, int.Parse(price)));
			else SignalManager.Instance.EmitSignal(SignalManager.SignalName.InvalidPrice, "Error: Not a number");
        }
	}
}