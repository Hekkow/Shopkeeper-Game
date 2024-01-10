using Godot;
using Godot.Collections;

public partial class RatioBars : Container
{
	Array<ProgressBar> bars = new();
	Array<Label> labels = new();
    public override void _Ready()
    {
		SignalManager.Instance.IngredientAddedToPot += OnIngredientAdded;
		SignalManager.Instance.IngredientsReset += OnIngredientsReset;
		InitializeBarsAndLabels();
		FillBars();
    }
    public override void _ExitTree()
    {
        SignalManager.Instance.IngredientAddedToPot -= OnIngredientAdded;
        SignalManager.Instance.IngredientsReset -= OnIngredientsReset;
    }
    void InitializeBarsAndLabels()
	{
		foreach (var item in GetChildren())
		{
			if (item is Button) continue;
			bars.Add(item.GetNode<ProgressBar>("ProgressBar"));
			labels.Add(item.GetNode<Label>("Label"));
		}
	}
	void OnIngredientAdded(InventorySlot inventorySlot)
	{
		FillBars();
	}
	void FillBars()
	{
		Element element = Element.IngredientToElement(Ingredients.Instance.pot.inv);
		Array<int> percentages = element.ElementToPercentages();
		for (int i = 0; i < bars.Count; i++)
		{
			bars[i].Value = percentages[i];
			labels[i].Text = element.GetArr()[i].ToString();
		}
	}
	void OnIngredientsReset()
	{
		for (int i = 0; i < bars.Count; i++)
		{
			bars[i].Value = 0;
			labels[i].Text = "0";
		}
	}
}
