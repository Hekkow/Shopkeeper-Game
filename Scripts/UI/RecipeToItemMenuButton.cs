using Godot;

public partial class RecipeToItemMenuButton : Button
{
    public override void _Pressed()
    {
        SignalManager.Instance.EmitSignal(SignalManager.SignalName.RecipeToItemMenuOpened);
    }
}