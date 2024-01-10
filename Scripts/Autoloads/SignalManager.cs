using Godot;
public partial class SignalManager : Node {
    public static SignalManager Instance;
    public override void _Ready()
    {
        Instance = this;
    }
    [Signal]
    public delegate void IngredientToRecipeMenuOpenedEventHandler();
    [Signal]
    public delegate void EscapeIngredientToRecipeEventHandler();
    [Signal]
    public delegate void IngredientAddedToPotEventHandler(InventorySlot inventorySlot);
    [Signal]
    public delegate void IngredientsResetEventHandler();
    [Signal]
    public delegate void IngredientRemovedFromInventoryEventHandler(InventorySlot inventorySlot);
    [Signal]
    public delegate void RecipeMadeEventHandler(Recipe recipe);
    [Signal]
    public delegate void PotDoneEventHandler();
    [Signal]
    public delegate void RecipeToItemMenuOpenedEventHandler();
    [Signal]
    public delegate void EscapeRecipeToItemEventHandler();
    [Signal]
    public delegate void EscapeRecipeToItemPriceModalEventHandler();
    [Signal]
    public delegate void RecipePressedEventHandler(Recipe recipe);
    [Signal]
    public delegate void RecipeRemovedFromInventoryEventHandler(InventorySlot inventorySlot);
    [Signal]
    public delegate void PriceModalSpawnedEventHandler(Recipe recipe);
    [Signal]
    public delegate void PriceModalDespawnedEventHandler();
    [Signal]
    public delegate void InvalidPriceEventHandler(string message);
    [Signal]
    public delegate void PriceSetEventHandler(Item item);
    [Signal]
    public delegate void ItemSpawnedEventHandler(Item item);
    [Signal]
    public delegate void ItemPlacedEventHandler(DisplayCase displayCase, Item item);
    [Signal]
    public delegate void ItemPlacementCancelledEventHandler(Item item);
    [Signal]
    public delegate void ItemPickedUpEventHandler(DisplayCase displayCase, Item item);
    [Signal]
    public delegate void StoreInitializedEventHandler();
    [Signal]
    public delegate void StoreOpenedEventHandler();
    [Signal]
    public delegate void CustomerSpawnedEventHandler(Character character);
    [Signal]
    public delegate void CustomerInterestedEventHandler(Character character, Item item);
    [Signal]
    public delegate void ItemSoldEventHandler(Item item);
    [Signal]
    public delegate void CustomerLeftEventHandler(Character character);
    [Signal]
    public delegate void PlayerMoneyUpdatedEventHandler(int money);
    [Signal]
    public delegate void StoreClosingEventHandler();
    [Signal]
    public delegate void StoreClosedEventHandler();
    [Signal]
    public delegate void AStarReadyEventHandler(AStarGrid2D astarGrid2D, TileMap tileMap);
    [Signal]
    public delegate void PathChangedEventHandler(Vector2[] path);
    [Signal]
    public delegate void RecipesReadyEventHandler();
    [Signal]
    public delegate void HagglingStartedEventHandler(Character character);
    [Signal]
    public delegate void HagglingEndedEventHandler(Character character, double scoreMultiplier);
    [Signal]
    public delegate void TextPressedEventHandler(TextTree textTree);
    [Signal]
    public delegate void ConversationDoneEventHandler(TextTree textTree);
}
