using Godot;

public partial class OpenScenesButtons : HBoxContainer
{
    public override void _Ready()
    {
		SignalManager.Instance.IngredientToRecipeMenuOpened += HideButtons;
		SignalManager.Instance.RecipeToItemMenuOpened += HideButtons;
		SignalManager.Instance.PotDone += HideButtons;
		SignalManager.Instance.EscapeRecipeToItem += ShowButtons;
		SignalManager.Instance.EscapeIngredientToRecipe += ShowButtons;
		SignalManager.Instance.StoreOpened += HideButtons;
		SignalManager.Instance.StoreClosed += ShowButtons;
    }
    public override void _ExitTree()
    {
        SignalManager.Instance.IngredientToRecipeMenuOpened -= HideButtons;
        SignalManager.Instance.RecipeToItemMenuOpened -= HideButtons;
        SignalManager.Instance.PotDone -= HideButtons;
        SignalManager.Instance.EscapeRecipeToItem -= ShowButtons;
        SignalManager.Instance.EscapeIngredientToRecipe -= ShowButtons;
        SignalManager.Instance.StoreOpened -= HideButtons;
        SignalManager.Instance.StoreClosed -= ShowButtons;
    }
    void HideButtons()
	{
		foreach (Button button in GetChildren()) button.Hide();
	}
    void ShowButtons()
    {
        foreach (Button button in GetChildren()) button.Show();
    }
}