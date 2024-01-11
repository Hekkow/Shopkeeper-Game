#if TOOLS
using Godot;

[Tool]
public partial class ResetTextBubbles : Button
{
    [Export] TextGenPanel panel;
    public override void _Ready()
    {
        Pressed += () => panel.Reset();
    }
}
#endif