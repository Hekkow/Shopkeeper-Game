using Godot;
using Godot.Collections;

public partial class Helper : Node {
	private static Helper _instance;
	public static Helper Instance => _instance;
	public enum Direction { UP, LEFT, DOWN, RIGHT, NONE}
	
	public void RemoveChildren(Node node) {
		foreach (Node child in node.GetChildren()) {
			node.RemoveChild(child);
			child.QueueFree();
		}
	}
	public Array GetFileNames(string path) {
		DirAccess dir = DirAccess.Open(path);
		var paths = new Array();
		if (dir is not null) {
			dir.ListDirBegin();
			string fileName = dir.GetNext();
			while (fileName != "") {
				paths.Add(fileName);
				fileName = dir.GetNext();
			}
		}
		return paths;
	}
	public Array<T> GetResources<[MustBeVariant] T>(string folder) where T : class {
		string folderPath = "res://Resources/" + folder;
        Array<T> resources = new();
		var paths = GetFileNames(folderPath);
		for (int i = 0; i < paths.Count; i++) {
			resources.Add(GD.Load<T>(folderPath + "/" + paths[i]));
		}
		return resources;
	}
    public Array RandomSample(Array array, int numberElements)
	{
		var arr = array.Duplicate();
		var elements = new Array();
		for (int i = 0; i < numberElements; i++)
		{
			int index = Data.Instance.rng.RandiRange(0, arr.Count - 1);
			elements.Add(arr[index]);
			arr.RemoveAt(index);
		}
		return elements;
	}
	public Direction CardinalDirection(Vector2 direction) {
		if (direction == Vector2.Zero) return Direction.NONE;
		if (Mathf.Abs(direction.X) > Mathf.Abs(direction.Y)) {
			if (direction.X < 0) return Direction.RIGHT;
			else return Direction.LEFT;
		}
		else {
			if (direction.Y < 0) return Direction.UP;
			else return Direction.DOWN;
		}
	}
	public T InstantiateWithScript<T>(Node parent, string path, string scriptPath, params object[] variables) where T : Node
	{
        Script script = GD.Load<Script>(scriptPath);
        Node node = GD.Load<PackedScene>(path).Instantiate();
        ulong nodeInstanceId = node.GetInstanceId();
        node.SetScript(script);
        T instantiatedClass = (T)InstanceFromId(nodeInstanceId);
		if (instantiatedClass is IVariableSettable)
		{
			((IVariableSettable)instantiatedClass).SetVariables(variables);
        }
        parent.AddChild(instantiatedClass);
		return instantiatedClass;
    }
	public override void _EnterTree(){
		if(_instance is not null) QueueFree();
		_instance = this;
	}
}

