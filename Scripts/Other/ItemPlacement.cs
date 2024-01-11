using Godot;

public partial class ItemPlacement : Node2D
{
	bool dragging = false;
	int maxCaseDistance = 70;
	Item item = null;
	Vector2 itemOffset = new(0, -47);
	Vector2 closestCaseMouseOffset = new(0, -20);
    DisplayCase previousCase = null;
	[Signal]
	public delegate void OnMouseEventHandler();

    public override void _Ready()
    {
		OnMouse += ItemClicked;
		SetProcessUnhandledInput(false);
		SignalManager.Instance.StoreOpened += OnStoreOpened;
		SignalManager.Instance.ItemSpawned += OnItemSpawned;
		SignalManager.Instance.ItemPlacementCancelled += OnItemPlacementCancelled;

    }
    public override void _ExitTree()
    {
        SignalManager.Instance.StoreOpened -= OnStoreOpened;
        SignalManager.Instance.ItemSpawned -= OnItemSpawned;
        SignalManager.Instance.ItemPlacementCancelled -= OnItemPlacementCancelled;

    }
    void OnItemSpawned(Item item)
	{
		dragging = true;
		this.item = item;
        SetProcessUnhandledInput(true);
	}
	void OnItemPlacementCancelled(Item item)
	{
        SetProcessUnhandledInput(false);
        if (previousCase is not null) SetCaseAlternative(previousCase);
    }
	void OnStoreOpened()
	{
        SetProcessUnhandledInput(false);
	}
	float Distance(Vector2 mousePosition, DisplayCase displayCase)
	{
		Vector2 position = Data.Instance.store.tilemap.MapToLocal(displayCase.coordinates) + closestCaseMouseOffset;
		return Mathf.Sqrt(Mathf.Pow((mousePosition.X - position.X), 2) + Mathf.Pow(mousePosition.Y - position.Y, 2));
	}
    DisplayCase FindClosestCase(bool empty = false)
	{
		float smallestDistance = 100000;
        DisplayCase closestCase = null;
		Vector2 mousePosition = GetViewport().GetMousePosition();
		foreach (var displayCase in Data.Instance.store.displayCases)
		{
            if (empty && displayCase.item is null) continue;
            float distance = Distance(mousePosition, displayCase);
			if (distance < smallestDistance)
			{
				smallestDistance = distance;
				closestCase = displayCase;
			}
		}
		if (Distance(mousePosition, closestCase) > maxCaseDistance) return null;
		return closestCase;
	}
    public override void _Process(double delta)
    {
		if (!dragging) return;
		item.Position = GetViewport().GetMousePosition();
        DisplayCase displayCase = FindClosestCase();
		if (displayCase is null)
		{
			if (previousCase is null) return;
			SetCaseAlternative(previousCase);
			previousCase = null;
			return;
		}
		if (displayCase != previousCase)
		{
			if (previousCase is not null) SetCaseAlternative(previousCase);
			SetCaseAlternative(displayCase, 4);
			previousCase = displayCase;
		}
    }

    void SetCaseAlternative(DisplayCase displayCase, int alternative=0)
	{
		TileMap tilemap = Data.Instance.store.tilemap;
		int sourceId = tilemap.GetCellSourceId(TilemapGen.displayCaseLayer, displayCase.coordinates);
		Vector2I atlasCoords = tilemap.GetCellAtlasCoords(TilemapGen.displayCaseLayer, displayCase.coordinates);
		tilemap.SetCell(TilemapGen.displayCaseLayer, displayCase.coordinates, sourceId, atlasCoords, alternative);
	}
    public override void _UnhandledInput(InputEvent e)
    {
        if (e is InputEventMouseButton)
		{
			InputEventMouseButton mouseEvent = (InputEventMouseButton)e;
			if (!mouseEvent.Pressed) return;
			if (mouseEvent.ButtonIndex == MouseButton.Left)
			{
				EmitSignal(SignalName.OnMouse);
			}
			else if (mouseEvent.ButtonIndex == MouseButton.Right) CancelDrag();
		}
		else if (e.IsActionPressed("ui_cancel"))
		{
			if (dragging) CancelDrag();
		}
    }
	void CancelDrag()
	{
		dragging = false;
		SignalManager.Instance.EmitSignal(SignalManager.SignalName.ItemPlacementCancelled, item);
		Items.Instance.store.Remove(item);
		item.QueueFree();
    }
	void ItemClicked()
    {
		DisplayCase displayCase = FindClosestCase(!dragging);
		if (displayCase is null) return;
		if (!dragging)
		{
            if (displayCase.item is null) return;
			dragging = true;
			item = displayCase.item;
			SignalManager.Instance.EmitSignal(SignalManager.SignalName.ItemPickedUp, displayCase, item);
			displayCase.item = null;
		}
		else
		{
			if (displayCase.item is not null) return;
			SetCaseAlternative(previousCase);
			dragging = false;
			item.Position = Data.Instance.store.tilemap.MapToLocal(displayCase.coordinates) + itemOffset;
            displayCase.item = item;
            SignalManager.Instance.EmitSignal(SignalManager.SignalName.ItemPlaced, displayCase, item);
			item = null;

        }
    }
}