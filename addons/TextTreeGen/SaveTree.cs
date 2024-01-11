#if TOOLS
using Godot;

[Tool]
public partial class SaveTree : Button
{
    [Export] TextGenPanel panel;
    public override void _Ready()
    {
        Pressed += () => panel.SaveFile();
    }
}
#endif