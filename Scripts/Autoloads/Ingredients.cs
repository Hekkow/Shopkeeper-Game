using Godot;
using Godot.Collections;

public partial class Ingredients : Node {
	public static Ingredients Instance;
	Array<Ingredient> list;
	public Inventory inventory = new();
	public Inventory pot = new();
    public override void _Ready()
    {
		Instance = this;
		list = Helper.Instance.GetResources<Ingredient>("Ingredients");
		foreach (Ingredient ingredient in list) inventory.Add(ingredient, 30);
		SignalManager.Instance.IngredientAddedToPot += OnIngredientAdded;
		SignalManager.Instance.IngredientsReset += OnIngredientsReset;
		SignalManager.Instance.RecipeMade += OnRecipeMade;
		for (int i = 0; i < list.Count; i++)
		{
			inventory.Add(list[i], 30);
		}
    }
	void OnIngredientAdded(InventorySlot slot)
	{
		pot.Add(slot.obj);
		if (slot.Subtract() == 0) inventory.Remove(slot.obj);
		SignalManager.Instance.EmitSignal(SignalManager.SignalName.IngredientRemovedFromInventory, slot);
	}
	void OnIngredientsReset()
	{
		for (int i = pot.inv.Count - 1; i >= 0; i--)
		{
			InventorySlot slot = pot.inv[i];
			inventory.Add(slot);
			pot.Remove(slot);
		}
	}
	void OnRecipeMade(Recipe recipe)
	{
		pot.Clear();
		if (inventory.IsEmpty()) SignalManager.Instance.EmitSignal(SignalManager.SignalName.PotDone);
	}
}