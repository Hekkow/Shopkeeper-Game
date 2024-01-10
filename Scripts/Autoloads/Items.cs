using Godot;
using Godot.Collections;

public partial class Items : Node
{
    public int id = 0;
    public Array<Item> store = new();
    public static Items Instance;
    public override void _Ready()
    {
        Instance = this;
        SignalManager.Instance.CustomerInterested += OnCustomerInterested;
    }
    public void OnCustomerInterested(Character character, Item item)
    {
        RemoveFromStore(item);
        if (store.Count == 0) SignalManager.Instance.EmitSignal(SignalManager.SignalName.StoreClosing);
    }
    public void RemoveFromStore(Item item)
    {
        int index = store.IndexOf(item);
        if (index != -1)
        {
            store.RemoveAt(index);
            return;
        }
    }
}