using Godot;
public partial class PriceModalDefaultButton : Button
{
	Recipe recipe;
    public override void _Ready()
    {
        SignalManager.Instance.PriceModalSpawned += SetRecipe;
        SignalManager.Instance.RecipePressed += SetRecipe;
    }
    public override void _ExitTree()
    {
        SignalManager.Instance.PriceModalSpawned -= SetRecipe;
        SignalManager.Instance.RecipePressed -= SetRecipe;
    }
    void SetRecipe(Recipe recipe)
    {
        this.recipe = recipe;
    }
    public override void _Pressed()
    {
        SignalManager.Instance.EmitSignal(SignalManager.SignalName.PriceSet, new Item(recipe));
    }

}