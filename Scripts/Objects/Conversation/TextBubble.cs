using Godot;

public partial class TextBubble : Button
{
	TextTree textTree;
    public override void _Ready()
    {
		Text = textTree.speaker + ": " + textTree.data;
		Pressed += OnPressed;
    }
    void OnPressed()
    {
		if (textTree.branches.Count == 0) SignalManager.Instance.EmitSignal(SignalManager.SignalName.ConversationDone, textTree);
		else SignalManager.Instance.EmitSignal(SignalManager.SignalName.TextPressed, textTree);
    }
	public void SetVariables(TextTree textTree)
	{
		this.textTree = textTree;
	}
}