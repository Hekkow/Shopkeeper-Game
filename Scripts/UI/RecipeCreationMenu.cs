using Godot;

public partial class RecipeCreationMenu : Node
{
    public override void _Ready()
    {
        SignalManager.Instance.PotDone += CloseMenu;
        SignalManager.Instance.EscapeIngredientToRecipe += CloseMenu;
    }
    public override void _ExitTree()
    {
        SignalManager.Instance.PotDone -= CloseMenu;
        SignalManager.Instance.EscapeIngredientToRecipe -= CloseMenu;
    }
    void CloseMenu()
    {
        QueueFree();
    }
}