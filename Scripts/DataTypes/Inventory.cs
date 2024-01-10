using Godot;
using Godot.Collections;
using System.Linq;
using System.Xml.Linq;

public partial class Inventory : Node
{
	public Array<InventorySlot> inv = new();

	public int FindIndex(object item)
	{
		for (int i = 0; i < inv.Count; i++)
		{
			if (inv[i].obj == item) return i;
		}
		return -1;
	}
    public InventorySlot Find(object item)
    {
        for (int i = 0; i < inv.Count; i++)
        {
            if (inv[i].obj == item) return inv[i];
        }
        return null;
    }

    public void Add(object item, int amount = 1)
	{
		int index = FindIndex(item);
        if (index != -1)
        {
            inv[index].amount += amount;
        }
        else
        {
            inv.Add(new InventorySlot(item, amount));
        }
	}
    public void Add(InventorySlot slot)
    {
        int index = FindIndex(slot.obj);
        if (index != -1) inv[index].amount += slot.amount;
        else inv.Append(slot);
    }
    public void Remove(object item)
	{
        int index = FindIndex(item);
		if (index != -1) inv.RemoveAt(index);
    }
    public void Remove(InventorySlot slot)
    {
        int index = FindIndex(slot.obj);
        if (index != -1) inv.RemoveAt(index);
    }
    public void Clear()
    {
        inv = new();
    }
    public bool IsEmpty()
    {
        return inv.Count == 0;
    }
    public override string ToString()
    {
        string str = "";
        for (int i = 0; i < inv.Count; i++)
        {
            str += inv[i].ToString();
        }
        return str;
    }
}