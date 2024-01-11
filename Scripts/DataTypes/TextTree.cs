using Godot;
using Godot.Collections;

public partial class TextTree : Tree
{
	public string speaker;
	public new Array<TextTree> branches = new();
    public TextTree() : this("", "") { }
	public TextTree(string speaker, object data, TextTree parent = null, int level = 0) : base(data, parent, level)
	{
		this.speaker = speaker;
	}
	public TextTree Add(string speaker, object data)
	{
		TextTree textTree = new(speaker, data, this, level + 1);
		branches.Add(textTree);
		return textTree;
	}
    public TextTree Add(TextTree tree)
    {
        tree.level = level + 1;
        tree.parent = this;
        branches.Add(tree);
        return tree;
    }
    public TextTree Root(TextTree tree = null)
    {
        return (TextTree)base.Root(tree);
    }
    public override string ToString()
    {
        string str = "";
        if (parent is not null) str += "\n";
        for (int i = 0; i < level; i++) str += " ";
        str += level.ToString() + " " + speaker + ": " + data.ToString();
        for (int i = 0; i < branches.Count; i++) str += branches[i].ToString();
        return str;
    }
}