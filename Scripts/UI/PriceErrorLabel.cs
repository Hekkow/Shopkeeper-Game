using Godot;

public partial class PriceErrorLabel : Label
{
    public override void _Ready()
    {
        SignalManager.Instance.InvalidPrice += OnInvalidPrice;
    }
    public override void _ExitTree()
    {
        SignalManager.Instance.InvalidPrice -= OnInvalidPrice;
    }
    void OnInvalidPrice(string message)
    {
        Text = message;
    }
}