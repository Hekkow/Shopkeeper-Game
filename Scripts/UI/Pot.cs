using Godot;
using System;
public partial class Pot : Container
{
    public override void _Ready()
    {
        SignalManager.Instance.IngredientAddedToPot += OnIngredientAdded;
        SignalManager.Instance.IngredientsReset += OnIngredientsReset;
		CheckForRecipes();
    }
    public override void _ExitTree()
    {
        SignalManager.Instance.IngredientAddedToPot -= OnIngredientAdded;
        SignalManager.Instance.IngredientsReset -= OnIngredientsReset;
    }
    void OnIngredientAdded(InventorySlot inventorySlot)
    {
        if (GetChildCount() > 0) GetChild(0).QueueFree();
        CheckForRecipes();
    }
	void OnIngredientsReset()
	{
		if (GetChildCount() > 0) GetChild(0).QueueFree();
	}
	void CheckForRecipes()
	{
		Recipe recipe = Recipes.Instance.CheckRecipes(Element.IngredientToElement(Ingredients.Instance.pot.inv));
		if (recipe is null) return;
        Helper.Instance.InstantiateWithScript<PotButton>(this, "res://Scenes/UI/ItemDisplayButton.tscn", "res://Scripts/UI/PotButton.cs", recipe);
    }
}