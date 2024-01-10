using Godot;

public partial class InventorySlot : Resource {
	public object obj;
	public int amount;
	public InventorySlot(object obj = default, int amount = 1) {
		this.obj = obj;
		this.amount = amount;
	}
	public int Subtract() {
		if (amount > 0) {
			amount--;
			return amount;
		}
		return -1;
	}
    public override bool Equals(object obj)
    {
        if (obj is InventorySlot other)
        {
            return this.obj.Equals(other.obj);
        }
        return this.obj.Equals(obj);
    }
    public static bool operator ==(InventorySlot lhs, InventorySlot rhs)
    {
        return lhs.Equals(rhs);
    }
    public static bool operator !=(InventorySlot lhs, InventorySlot rhs)
    {
        return !lhs.Equals(rhs);
    }
    public static bool operator ==(InventorySlot lhs, object rhs)
    {
        return lhs.Equals(rhs);
    }
    public static bool operator !=(InventorySlot lhs, object rhs)
    {
        return !lhs.Equals(rhs);
    }
    public override int GetHashCode()
    {
        return base.GetHashCode();
    }
    public override string ToString() {
        return $"{obj} ({amount})";
    }
}