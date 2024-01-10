using Godot;
using Godot.Collections;

public partial class Tree : Node
{
	public object data;
	public Array<Tree> branches = new();
	protected Tree parent;
	public int level;
	public Tree(object data, Tree parent=null, int level=0)
	{
		this.data = data;
		this.parent = parent;
		this.level = level;
	}
    public Tree Add(Tree tree)
    {
        tree.level = level + 1;
        tree.parent = this;
        branches.Add(tree);
        return tree;
    }
    public Tree Add(object data)
	{
		Tree tree = new(data, this, level + 1);
		branches.Add(tree);
		return tree;
	}
	public Tree Root(Tree tree=null)
	{
		if (tree == null) tree = this;
		if (tree.parent == null) return tree;
		return Root(tree.parent);
	}
    public override string ToString()
    {
		string str = "";
		if (parent != null) str += "\n";
		for (int i = 0; i < level; i++) str += " ";
		str += data.ToString();
		for (int i = 0; i < branches.Count; i++) str += branches[i].ToString();
		return str;
    }
}
