using Godot;

public partial class ResetIngredientsButton : Button
{
    public override void _Pressed()
    {
        SignalManager.Instance.EmitSignal(SignalManager.SignalName.IngredientsReset);
    }
}