using Godot;
using Godot.Collections;

public partial class TilemapGen : TileMap
{
	public static int displayCaseLayer = 1;
	AStarGrid2D astar;
	int groundLayer = 0;
	int[] solidLayers = { 1, 2, 3 };
	bool showCellNumbers = false;
	AStarGrid2D.Heuristic heuristic = AStarGrid2D.Heuristic.Chebyshev;
	AStarGrid2D.DiagonalModeEnum diagonalMode = AStarGrid2D.DiagonalModeEnum.Never;
	Array<DisplayCase> displayCases = new();

    public override void _Ready()
    {
		SignalManager.Instance.StoreInitialized += OnStoreInitialized;
        astar = new() {
            Region = GetUsedRect(),
            CellSize = TileSet.TileSize,
            DiagonalMode = diagonalMode,
            DefaultComputeHeuristic = heuristic,
            DefaultEstimateHeuristic = heuristic
        };
        astar.Update();
		if (showCellNumbers)
		{
			foreach (Vector2I cell in GetUsedCells(groundLayer))
			{
				Label label = new();
				label.Text = cell.ToString();
				label.ZIndex = 100;
				AddChild(label);
				label.Position = MapToLocal(cell) - label.Size / 2;
			}
		}
		for (int i = 0; i < solidLayers.Length; i++)
		{
            foreach (Vector2I cell in GetUsedCells(solidLayers[i])) astar.SetPointSolid(cell);
        }
		foreach (Vector2I cell in GetUsedCells(displayCaseLayer))
		{
			DisplayCase test = new(cell);
			displayCases.Add(test);
		}
    }
    public override void _ExitTree()
    {
        SignalManager.Instance.StoreInitialized -= OnStoreInitialized;
    }
    void OnStoreInitialized()
	{
		Data.Instance.store.astar = astar;
		Data.Instance.store.tilemap = this;
		Data.Instance.store.displayCases = displayCases;
    }
}
