#if TOOLS
using Godot;

[Tool]
public partial class LoadTree : Button
{
    [Export] TextGenPanel panel;
    public override void _Ready()
    {
        Pressed += () => panel.LoadFile();
    }
}
#endif