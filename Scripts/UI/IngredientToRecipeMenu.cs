using Godot;

public partial class IngredientToRecipeMenu : GridContainer
{
    public override void _Ready()
    {
        InitializeIngredients();
        SignalManager.Instance.IngredientsReset += OnIngredientsReset;
    }
    public override void _ExitTree()
    {
        SignalManager.Instance.IngredientsReset -= OnIngredientsReset;
    }
    void OnIngredientsReset()
    {
        Helper.Instance.RemoveChildren(this);
        InitializeIngredients();
    }
    void InitializeIngredients()
    {
        foreach (InventorySlot slot in Ingredients.Instance.inventory.inv)
        {
            Helper.Instance.InstantiateWithScript<IngredientButton>(this, "res://Scenes/UI/ItemDisplayButton.tscn", "res://Scripts/UI/IngredientButton.cs", slot);
        }
    }
}