using Godot;

public partial class PlayerStats : Node
{
	public static PlayerStats Instance = new PlayerStats();
	public int money = 0;
    public override void _Ready()
    {
		SignalManager.Instance.ItemSold += OnItemSold;
    }
	void OnItemSold(Item item)
	{
		money += item.soldPrice;
		SignalManager.Instance.EmitSignal(SignalManager.SignalName.PlayerMoneyUpdated, money);
	}
}