using Godot;

public partial class PotDoneButton : Button
{
    public override void _Pressed()
    {
        SignalManager.Instance.EmitSignal(SignalManager.SignalName.PotDone);
    }
}