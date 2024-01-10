using Godot;
using Godot.Collections;
using System.Collections.Generic;

public partial class Store : Node2D
{
	PackedScene itemScene = GD.Load<PackedScene>("res://Scenes/Objects/Item.tscn");
    PackedScene characterScene = GD.Load<PackedScene>("res://Scenes/Objects/Character.tscn");
	Resource itemClass = GD.Load("res://Scripts/Objects/Item.cs");
    [Export] public Array<DisplayCase> displayCases;
    Array<Character> customers = new();
	bool storeOpen = false;
	public TileMap tilemap;
	public AStarGrid2D astar;
    public override void _Ready()
    {
		Data.Instance.store = this;
		SignalManager.Instance.StoreOpened += OnStoreOpened;
		SignalManager.Instance.PriceSet += SpawnItem;
		SignalManager.Instance.CustomerLeft += OnCustomerLeft;
		SignalManager.Instance.StoreClosing += OnStoreClosing;
		SignalManager.Instance.EmitSignal(SignalManager.SignalName.StoreInitialized);
    }
    public override void _ExitTree()
    {
        SignalManager.Instance.StoreOpened -= OnStoreOpened;
        SignalManager.Instance.PriceSet -= SpawnItem;
        SignalManager.Instance.CustomerLeft -= OnCustomerLeft;
        SignalManager.Instance.StoreClosing -= OnStoreClosing;
    }
    void OnStoreOpened()
	{
		storeOpen = true;
		if (Items.Instance.store.Count == 0)
		{
			SignalManager.Instance.EmitSignal(SignalManager.SignalName.StoreClosed);
			return;
		}
		SpawnCustomers();
	}
	void SpawnItem(Item item)
	{
		Item newItem = Helper.Instance.InstantiateWithScript<Item>(this, "res://Scenes/Objects/Item.tscn", "res://Scripts/Objects/Item.cs", item);
		SignalManager.Instance.EmitSignal(SignalManager.SignalName.ItemSpawned, newItem);
	}
	void OnStoreClosing()
	{
		storeOpen = false;
	}
	async void SpawnCustomers()
	{
		var customers = ChooseCustomers();
		foreach (CharacterStats customer in customers)
		{
			if (!storeOpen) return;
			if (GameState.Instance.state == GameState.State.Haggling)
			{
				await ToSignal(SignalManager.Instance, SignalManager.SignalName.HagglingEnded);
			}
			Character character = Helper.Instance.InstantiateWithScript<Character>(this, "res://Scenes/Objects/Character.tscn", "res://Scripts/Objects/Character.cs", customer);
			character.Name = customer.name;
			character.GetNode<AnimatedSprite2D>("AnimatedSprite2D").Modulate = customer.color;
			this.customers.Add(character);
			SignalManager.Instance.EmitSignal(SignalManager.SignalName.CustomerSpawned, character);
			await ToSignal(GetTree().CreateTimer(1), "timeout");
		}
	}
	Array<CharacterStats> ChooseCustomers()
	{ 
		//return [Helper.get_character("Green"), Helper.get_character("Blue"), Helper.get_character("Orange"), Helper.get_character("Salmon"), Helper.get_character("Red")]
		//return Helper.random_sample(Characters.list, _number_customers)
		//return [Characters.list[0]]
		return Characters.Instance.list;
	}
	void OnCustomerLeft(Character character)
	{
		for (int i = 0; i < customers.Count; i++)
		{
			if (customers[i].characterStats == character.characterStats)
			{
				customers.RemoveAt(i);
				break;
			}
		}
		if (customers.Count == 0) SignalManager.Instance.EmitSignal(SignalManager.SignalName.StoreClosed);
	}
	public Vector2I GetCaseCoordinates(Item item)
	{
		foreach (var displayCase in displayCases) {
			if (displayCase.item is not null && displayCase.item == item)
			{
                return displayCase.coordinates;
			}
		}
		return default;
	}
    public int GetCase(Vector2I coordinates)
    {
        for (int i = 0; i < displayCases.Count; i++)
        {
            if (coordinates == displayCases[i].coordinates)
            {
                return i;
            }
        }
        return -1;
    }
}