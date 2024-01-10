using Godot;
public partial class UI : CanvasLayer
{
    public override void _Ready()
    {
		SignalManager.Instance.RecipePressed += OnRecipePressed;
		SignalManager.Instance.IngredientToRecipeMenuOpened += OnIngredientToRecipeMenuOpened;
		SignalManager.Instance.RecipeToItemMenuOpened += OpenRecipeToItemMenu;
		SignalManager.Instance.PotDone += OpenRecipeToItemMenu;
    }
    public override void _ExitTree()
    {
        SignalManager.Instance.RecipePressed -= OnRecipePressed;
        SignalManager.Instance.IngredientToRecipeMenuOpened -= OnIngredientToRecipeMenuOpened;
        SignalManager.Instance.RecipeToItemMenuOpened -= OpenRecipeToItemMenu;
        SignalManager.Instance.PotDone -= OpenRecipeToItemMenu;
    }
    void InstantiateScene(string path)
	{
		AddChild(GD.Load<PackedScene>(path).Instantiate());
	}
	void OnRecipePressed(Recipe recipe)
	{
		InstantiateScene("res://Scenes/UI/PriceModal.tscn");
		SignalManager.Instance.EmitSignal(SignalManager.SignalName.PriceModalSpawned, recipe);
	}
	void OnIngredientToRecipeMenuOpened()
	{
		InstantiateScene("res://Scenes/UI/RecipeCreationMenu.tscn");
	}
	void OpenRecipeToItemMenu()
	{
		InstantiateScene("res://Scenes/UI/ItemCreationMenu.tscn");
	}
}