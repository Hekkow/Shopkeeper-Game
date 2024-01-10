using Godot;
using Godot.Collections;
public partial class Recipes : Node {
    Array<Recipe> list = new();
    public Inventory inventory = new();
    int maximum = 10000;
    public static Recipes Instance;
    public override void _Ready()
    {
        list = Helper.Instance.GetResources<Recipe>("Recipes");
        Instance = this;
        SignalManager.Instance.RecipeMade += OnRecipeMade;
        SignalManager.Instance.ItemPlaced += OnItemPlaced;
        SignalManager.Instance.ItemPickedUp += OnItemPickedUp;
        inventory.Add(list[0], 6);
    }
    public Recipe CheckRecipes(Element element)
    {
        int minimum = maximum;
        Array<int> values = new();
        var elements = element.GetArr();
        for (int i = 0; i < elements.Length; i++) {
            int amount = elements[i];
            if (amount < minimum && amount != 0) minimum = amount;
        }

        for (int i = 0; i < elements.Length; i++)
        {
            values.Add((int)((float)elements[i] / (float)minimum));
        }

        for (int i = 0; i < list.Count; i++) {
            if (list[i] == values)
            {
                return list[i];
            }
        }

        return null;
    }
    public void OnRecipeMade(Recipe recipe)
    {
        inventory.Add(recipe);
    }
    public void OnItemPlaced(DisplayCase displayCase, Item item)
    {
        InventorySlot slot = inventory.Find(item.recipe);
        if (slot.Subtract() == 0) inventory.Remove(slot.obj);
        SignalManager.Instance.EmitSignal("RecipeRemovedFromInventory", slot);
        if (inventory.inv.Count == 0) SignalManager.Instance.EmitSignal("EscapeRecipeToItem");
    }
    public void OnItemPickedUp(DisplayCase displayCase, Item item)
    {
        inventory.Add(item.recipe);
    }
    
}