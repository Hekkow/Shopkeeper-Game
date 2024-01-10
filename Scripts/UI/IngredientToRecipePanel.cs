using Godot;

public partial class IngredientToRecipePanel : Panel
{
    public override void _GuiInput(InputEvent @event)
    {
        if (@event is InputEventMouseButton && ((InputEventMouseButton)@event).IsPressed())
        {
            SignalManager.Instance.EmitSignal(SignalManager.SignalName.EscapeIngredientToRecipe);
        }
    }
    public override void _Input(InputEvent @event)
    {
        if (@event.IsActionPressed("ui_cancel"))
        {
            SignalManager.Instance.EmitSignal(SignalManager.SignalName.EscapeIngredientToRecipe);
        }
    }
}