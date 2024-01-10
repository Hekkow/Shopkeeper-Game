using Godot;

public partial class RecipeToItemNextButton : Button
{
    public override void _Pressed()
    {
        SignalManager.Instance.EmitSignal(SignalManager.SignalName.StoreOpened);
    }
}