
using Godot;
using Godot.Collections;

public partial class Characters : Node {
    public static Characters Instance;
    public Array<CharacterStats> list = new();
	int max_richness = 5;
	int max_friendship = 5;

    public override void _Ready() {
        Instance = this;
        list = Helper.Instance.GetResources<CharacterStats>("Characters");
    }
}
