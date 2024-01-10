using Godot;
using Godot.Collections;

public partial class Conversation : Control, IVariableSettable
{
	PackedScene textBubbleScene = GD.Load<PackedScene>("res://Scenes/UI/TextBubbles/TextBubble.tscn");
	TextTree textTree;
	int containerSeperation = 5;
	Vector2 pos;
	HBoxContainer container;
    public override void _Ready()
    {
		SignalManager.Instance.TextPressed += OnTextPressed;
		SignalManager.Instance.ConversationDone += OnConversationDone;
        
    }
    public override void _ExitTree()
    {
        SignalManager.Instance.TextPressed -= OnTextPressed;
        SignalManager.Instance.ConversationDone -= OnConversationDone;
    }
    
	void CreateTextBubbles(Array<TextTree> arr)
	{
		for (int i = 0; i < arr.Count; i++)
		{
			TextBubble textBubble = (TextBubble)textBubbleScene.Instantiate();
			textBubble.SetVariables(arr[i]);
			container.AddChild(textBubble);
		}
		Position = pos;
	}
	void OnTextPressed(TextTree textTree)
	{
		Helper.Instance.RemoveChildren(container);
		CreateTextBubbles(textTree.branches);
	}
	void OnConversationDone(TextTree textTree)
	{
		QueueFree();
	}
	TextTree LoadTreeFromFile(string fileName)
	{
		var file = FileAccess.Open("res://Resources/Conversations/" + fileName + ".txt", FileAccess.ModeFlags.Read);
		Array<string> lines = new();
		while (true)
		{
			string line = file.GetLine();
			if (line == "") break;
			lines.Add(line);
		}
        (string speaker, string text) rootData = GetDataLine(lines[0]);
		TextTree tree = new(rootData.speaker, rootData.text); ;
		Array<TextTree> branches = new(){tree};
		for (int i = 1; i < lines.Count; i++)
		{
			(string speaker, string text) nodeData = GetDataLine(lines[i]);
			TextTree node = new(nodeData.speaker.StripEdges(), nodeData.text);
			int level = GetLevel(nodeData.speaker);
			for (int y = i - 1; y >= 0; y--)
			{
				if (branches[y].level == level - 1)
				{
					branches[y].Add(node);
					branches.Add(node);
					break;
				}
			}
		}
		return tree;
	}
	(string speaker, string text) GetDataLine(string line)
	{
		string[] both = line.Split(":");
		string speaker = both[0];
		string text = both[1].Substring(1);
		return (speaker, text);
	}
	int GetLevel(string speaker)
	{
		float level = 0;
		for (int i = 0; i < speaker.Length; i++)
		{
			if (speaker[i] == ' ') level += 0.5f;
			else break;
		}
		return (int)level;
	}

    public void SetVariables(params object[] variables)
    {
		pos = (Vector2)variables[1];
        container = (HBoxContainer)GetNode("CenterContainer/HBoxContainer");
        textTree = LoadTreeFromFile((string)variables[0]);
        Array<TextTree> branches = new() { textTree };
        CreateTextBubbles(branches);
    }
}