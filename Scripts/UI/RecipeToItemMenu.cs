using Godot;

public partial class RecipeToItemMenu : GridContainer
{
    public override void _Ready()
    {
		LoadItems();
    }
	void LoadItems()
	{
		foreach (InventorySlot inventorySlot in Recipes.Instance.inventory.inv)
		{
            Helper.Instance.InstantiateWithScript<RecipeButton>(this, "res://Scenes/UI/ItemDisplayButton.tscn", "res://Scripts/UI/RecipeButton.cs", inventorySlot);
        }
	}
}