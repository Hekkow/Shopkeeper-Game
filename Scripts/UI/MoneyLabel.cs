using Godot;

public partial class MoneyLabel : Label
{
    public override void _Ready()
    {
        SignalManager.Instance.PlayerMoneyUpdated += OnPlayerMoneyUpdated;
        Text = "$" + PlayerStats.Instance.money.ToString();
    }
    public override void _ExitTree()
    {
        SignalManager.Instance.PlayerMoneyUpdated -= OnPlayerMoneyUpdated;
    }
    void OnPlayerMoneyUpdated(int money)
    {
        Text = "$" + money.ToString();
    }
}