using Godot;

public partial class IngredientButton : Button, IVariableSettable
{
    public InventorySlot inventorySlot;
	public override void _Ready()
	{
		Text = inventorySlot.ToString();
		SignalManager.Instance.IngredientRemovedFromInventory += OnIngredientRemovedFromInventory;
		Pressed += OnPressed;
	}
    public override void _ExitTree()
    {
        SignalManager.Instance.IngredientRemovedFromInventory -= OnIngredientRemovedFromInventory;
    }
    void OnPressed()
    {
		SignalManager.Instance.EmitSignal(SignalManager.SignalName.IngredientAddedToPot, inventorySlot);
    }
	void OnIngredientRemovedFromInventory(InventorySlot slot)
	{
		if (this.inventorySlot != slot) return;
		if (slot.amount == 0) QueueFree();
		else Text = slot.ToString();
	}

    public void SetVariables(params object[] variables)
    {
        inventorySlot = (InventorySlot)variables[0];
    }
}
