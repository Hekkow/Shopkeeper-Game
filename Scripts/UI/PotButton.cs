using Godot;

public partial class PotButton : Button, IVariableSettable
{
	public Recipe recipe;
    public override void _Ready()
    {
		Text = recipe.name;
    }
    public override void _Pressed()
    {
        SignalManager.Instance.EmitSignal(SignalManager.SignalName.RecipeMade, recipe);
        SignalManager.Instance.EmitSignal(SignalManager.SignalName.IngredientsReset);
        QueueFree();
    }

    public void SetVariables(params object[] variables)
    {
        recipe = (Recipe)variables[0];
    }
}