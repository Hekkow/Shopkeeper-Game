using Godot;
using Godot.Collections;

public partial class Character: Area2D, Interactable, IVariableSettable {
	[Export] public CharacterStats characterStats;
	[Export] bool debugDraw;
	[Export] CollisionShape2D collisionShape;
	float speed = 3;
    float minDistance = 3;
    Item interestedItem;
	Item interestedItemNode;
	bool paused = false;
	bool hagglingPaused = false;
	Array<Item> priorityQueue = new();
	Store store;
	Vector2I exit = new(11, 10);
	Vector2I table = new(11, 2);
	AnimatedSprite2D animatedSprite;
	enum State { LOOKING, BUYING, LEAVING }
	State state;
	Array<Vector2I> path = new(); 
	

    public void SetVariables(params object[] variables)
    {
		characterStats = (CharacterStats)variables[0];
    }
    public Character() : this(null) { }
    public Character(CharacterStats characterStats = null) {
		SetVariables(characterStats);
	}
	public override void _Ready() {
        if (GameState.Instance.state == GameState.State.Shopping) {
            store = Data.Instance.store;
            collisionShape = GetNode<CollisionShape2D>("CollisionShape2D");
            animatedSprite = GetNode<AnimatedSprite2D>("AnimatedSprite2D");
            SetPhysicsProcess(false);
            Position = store.tilemap.MapToLocal(exit) - collisionShape.GlobalTransform.Origin;
            SignalManager.Instance.CustomerInterested += OnOtherCustomerInterested;
            SignalManager.Instance.HagglingStarted += OnHagglingStarted;
            SignalManager.Instance.HagglingEnded += OnHagglingEnded;
            priorityQueue = GetPriorities();
            VisitRandomItem();
        }
		else if (GameState.Instance.state == GameState.State.World) { }
    }
    public override void _ExitTree()
    {
        SignalManager.Instance.CustomerInterested -= OnOtherCustomerInterested;
        SignalManager.Instance.HagglingStarted -= OnHagglingStarted;
        SignalManager.Instance.HagglingEnded -= OnHagglingEnded;
    }
    Array<Item> GetPriorities()
	{
		return Items.Instance.store;
	}
	Item GetNextPriority()
	{
		return priorityQueue[0];
	}
	void VisitRandomItem()
	{
		if (priorityQueue.Count == 0) {
			LeaveStore();
			return;
		}
		interestedItemNode = GetNextPriority();
		interestedItem = interestedItemNode.Dupe();
		SetDestinationPath(store.GetCaseCoordinates(interestedItem), State.LOOKING);
	}
	bool Interested(Item item)
	{
		return Data.Instance.rng.Randf() <= 1;
	}
	async void OnItemReached()
	{
		Pause(0.5);
		if (GameState.Instance.state == GameState.State.Haggling)
		{
			await ToSignal(SignalManager.Instance, SignalManager.SignalName.HagglingEnded);
		}
		if (Interested(interestedItem)) {
			SignalManager.Instance.EmitSignal(SignalManager.SignalName.CustomerInterested, this, interestedItem);
			await ToSignal(GetTree().CreateTimer(0.5), "timeout");
			interestedItemNode.QueueFree();
			SetDestinationPath(table, State.BUYING);
        }
		else
		{
			priorityQueue.RemoveAt(0); //- change
			VisitRandomItem();
		}
	}
	void Haggle()
	{
		SignalManager.Instance.EmitSignal(SignalManager.SignalName.HagglingStarted, this);
	}
	void OnHagglingStarted(Character character = null)
	{
		HagglingStop();
	}
	void OnHagglingEnded(Character character, double scoreMultiplier)
	{
		if (character == this) Buy(scoreMultiplier);
		HagglingStart();
	}
	void Buy(double scoreMultiplier)
	{
		interestedItem.soldPrice = (int)(interestedItem.price * scoreMultiplier);
		SignalManager.Instance.EmitSignal(SignalManager.SignalName.ItemSold, interestedItem);
		LeaveStore();
	}
	void LeaveStore()
	{
		SetDestinationPath(exit, State.LEAVING);
		SignalManager.Instance.CustomerInterested -= OnOtherCustomerInterested;
	}
	void OnReachedDoor()
	{
		SignalManager.Instance.EmitSignal(SignalManager.SignalName.CustomerLeft, this);
		QueueFree();
	}
	void OnOtherCustomerInterested(Character character, Item item)
	{
		for (int i = 0; i < priorityQueue.Count; i++)
		{
			if (priorityQueue[i] == item)
			{
				priorityQueue.RemoveAt(i);
				break;
			}
		}
        if (character == this || item != interestedItem) return;
        VisitRandomItem();
	}
	async void Pause(double seconds)
	{
		Stop();
		await ToSignal(GetTree().CreateTimer(seconds), "timeout");
		Start();
	}
	void Stop()
	{
		animatedSprite.Stop();
		paused = true;
	}
	void Start()
	{
		paused = false;
	}
	void HagglingStart()
	{
		hagglingPaused = false;
	}
	void HagglingStop()
	{
		animatedSprite.Stop();
		hagglingPaused = true;
	}
	void SetDestinationPath(Vector2I destination, State state)
	{
		this.state = state;

		path = GetShortestPath(store.tilemap.LocalToMap(collisionShape.GlobalTransform.Origin), destination);
		SetPhysicsProcess(true);
	}
	Array<Vector2I> GetShortestPath(Vector2I start, Vector2I destination)
	{
		if (!store.astar.IsPointSolid(destination)) return store.astar.GetIdPath(start, destination);
		Array<Vector2I> shortestPath = store.astar.GetIdPath(start, store.tilemap.GetNeighborCell(destination, 0));
		for (int i = 0; i <= 12; i += 4)
		{
			Vector2I neighborCell = store.tilemap.GetNeighborCell(destination, (TileSet.CellNeighbor)i);
			if (store.astar.IsPointSolid(neighborCell)) continue;
			Array<Vector2I> neighborPath = store.astar.GetIdPath(start, neighborCell);
			if (shortestPath.Count == 0 || neighborPath.Count < shortestPath.Count) shortestPath = neighborPath;
		}
		return shortestPath;
	}
    public override void _Draw()
    {
		if (!debugDraw || path.Count == 0) return;
		Vector2 last = store.tilemap.MapToLocal(path[0]) - Position;
		for (int i = 0; i < path.Count - 1; i++)
		{
			Vector2 from = store.tilemap.MapToLocal(path[i]);
			Vector2 to = store.tilemap.MapToLocal(path[i+1]);
			DrawLine(last, last + to - from, characterStats.color);
			last += to - from;
        }
    }
	void LookDirection(Vector2 to)
	{
		Vector2 direction = to - collisionShape.GlobalTransform.Origin;
		switch (Helper.Instance.CardinalDirection(direction))
		{
			case Helper.Direction.UP:
				animatedSprite.Play("up");
				break;
			case Helper.Direction.DOWN:
				animatedSprite.Play("down");
				break;
			case Helper.Direction.LEFT:
				animatedSprite.Play("side");
				animatedSprite.FlipH = true;
				break;
			case Helper.Direction.RIGHT:
				animatedSprite.Play("side");
				animatedSprite.FlipH = false;
				break;
		}
	}
	void DestinationReached()
	{
		switch (state)
		{
			case State.LOOKING:
				LookDirection(interestedItemNode.Position);
				OnItemReached();
				break;
			case State.BUYING:
				LookDirection(store.tilemap.MapToLocal(table));
				Haggle();
				break;
			case State.LEAVING:
				OnReachedDoor();
				break;
		}
		animatedSprite.Stop();
	}
    public override void _PhysicsProcess(double delta)
    {
		if (paused || hagglingPaused || path.Count == 0) return;
		if (debugDraw) QueueRedraw();
		Vector2 nextPoint = store.tilemap.MapToLocal(path[0]);
		Vector2 pos = collisionShape.GlobalTransform.Origin;
		LookDirection(nextPoint);
		double distance = pos.DistanceTo(nextPoint);
		if (distance < minDistance)
		{
			path.RemoveAt(0);
			if (path.Count == 0)
			{
				SetPhysicsProcess(false);
				DestinationReached();
				return;
			}
			nextPoint = store.tilemap.MapToLocal(path[0]);
		}
		Vector2 direction = (nextPoint - pos).Normalized();
		Position += direction * speed;
    }
    public override string ToString() => characterStats.name;

    public void Interact()
    {
		Node conversation = GD.Load<PackedScene>("res://Scenes/UI/TextBubbles/Conversation.tscn").Instantiate();
		((IVariableSettable)conversation).SetVariables("Black-test", Position + new Vector2(0, -80));
		GetParent().AddChild(conversation);
    }

    
}
    //func get_priorities() -> Array:
    //	var priorities = []
    //	for item in Items.store:
    //		var prio = 0
    //		if Helper.find_index(customer.affinity, item.recipe) != -1:
    //			prio += 100
    //		prio -= customer.personality.diff(item.recipe.element)
    //		priorities.append(Priority.new(item, prio))
    //	PriorityList.sort(priorities)
    //	var items = []
    //	for item in priorities:
    //		items.append(item.obj)
    //	return items