using Godot;

public partial class RecipeButton : Button, IVariableSettable
{
	public InventorySlot inventorySlot;
    public override void _Ready()
    {
        Text = inventorySlot.ToString();
		SignalManager.Instance.RecipeRemovedFromInventory += OnRecipeRemovedFromInventory;
        Pressed += OnPressed;
    }
    public override void _ExitTree()
    {
        SignalManager.Instance.RecipeRemovedFromInventory -= OnRecipeRemovedFromInventory;
    }
    void OnPressed()
    {
		SignalManager.Instance.EmitSignal(SignalManager.SignalName.RecipePressed, (Recipe)inventorySlot.obj);
		Text = inventorySlot.ToString();
    }
	void OnRecipeRemovedFromInventory(InventorySlot inventorySlot)
	{
		if (this.inventorySlot != inventorySlot) return;
		if (inventorySlot.amount == 0) QueueFree();
		else Text = inventorySlot.ToString();
	}

    public void SetVariables(params object[] variables)
    {
        inventorySlot = (InventorySlot)variables[0];
    }
}