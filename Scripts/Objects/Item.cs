using Godot;

public partial class Item : Sprite2D, IVariableSettable {
	[Export] public Recipe recipe;
	[Export] public int price = -1;
	[Export] public int soldPrice = -1;
	[Export] public int id;
	Label label;
    public override void _Ready()
    {
        label = GetNode("Label") as Label;
		SignalManager.Instance.ItemPlaced += OnItemPlaced;
		SignalManager.Instance.ItemPickedUp += OnItemPickedUp;
    }
    public override void _ExitTree()
    {
        SignalManager.Instance.ItemPlaced -= OnItemPlaced;
        SignalManager.Instance.ItemPickedUp -= OnItemPickedUp;
    }
    public Item() : this(null, -1) { }
    public Item(Recipe recipe = null, int price = -1)
	{
		this.recipe = recipe;
		this.price = price;
		id = Items.Instance.id;
		Items.Instance.id++;
	}
	public Item(Recipe recipe)
	{
		this.recipe = recipe;
		this.price = recipe.basePrice;
		id = Items.Instance.id;
		Items.Instance.id++;
	}
	public void OnItemPlaced(DisplayCase displayCase, Item item)
	{
		if (item != this) return;
		label.Text = "$" + price.ToString();
	}
	public void OnItemPickedUp(DisplayCase displayCase, Item item)
	{
		if (item != this) return;
		label.Text = "";
	}
	public void SetVariables(params object[] variables)
	{
		Item item = (Item)variables[0];
		price = item.price;
		recipe = item.recipe;
		id = item.id;
		Items.Instance.store.Add(this);
	}
	public Item Dupe()
	{
		Item item = new(recipe, price);
		item.soldPrice = soldPrice;
		item.id = id;
		return item;
	}

    public override bool Equals(object obj)
    {
        return id == ((Item)obj).id;
    }
    public static bool operator ==(Item lhs, object rhs)
    {
        return lhs.Equals(rhs);
    }
	public static bool operator !=(Item lhs, object rhs)
	{
        return !lhs.Equals(rhs);
	}
    public override int GetHashCode()
    {
        return base.GetHashCode();
    }

    public override string ToString()
    {
		return $"{recipe.name}, id: {id}";
    }
}