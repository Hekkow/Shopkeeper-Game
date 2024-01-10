using Godot;

public partial class GameState : Node
{
	public static GameState Instance;
	public enum State { Haggling, Shopping, World }
	public State state = State.World;
	public override void _Ready()
    {
		Instance = this;
		SignalManager.Instance.HagglingStarted += OnHagglingStarted;
		SignalManager.Instance.HagglingEnded += OnHagglingEnded;
    }
	void OnHagglingStarted(Character character)
	{
		state = State.Haggling;
	}
	void OnHagglingEnded(Character character, double scoreMultiplier)
	{
		state = State.Shopping;
	}
}