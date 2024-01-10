using Godot;
public partial class IngredientToRecipeMenuButton : Button
{
    public override void _Pressed()
    {
        SignalManager.Instance.EmitSignal(SignalManager.SignalName.IngredientToRecipeMenuOpened);
    }
}