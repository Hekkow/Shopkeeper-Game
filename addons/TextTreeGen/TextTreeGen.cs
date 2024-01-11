#if TOOLS
using Godot;

[Tool]
public partial class TextTreeGen : EditorPlugin
{
    PackedScene MainPanel = ResourceLoader.Load<PackedScene>("res://addons/TextTreeGen/TextGenPanel.tscn");
    Control MainPanelInstance;

    public override void _EnterTree()
    {
        MainPanelInstance = (Control)MainPanel.Instantiate();
        EditorInterface.Singleton.GetEditorMainScreen().AddChild(MainPanelInstance);
        _MakeVisible(false);
    }
    public override void _ExitTree()
    {
        if (MainPanelInstance is not null)
        {
            MainPanelInstance.QueueFree();
        }
    }
    public override bool _HasMainScreen()
    {
        return true;
    }
    public override void _MakeVisible(bool visible)
    {
        if (MainPanelInstance is not null)
        {
            MainPanelInstance.Visible = visible;
        }
    }
    public override string _GetPluginName()
    {
        return "Text Tree Gen";
    }
    public override Texture2D _GetPluginIcon()
    {
        return EditorInterface.Singleton.GetEditorTheme().GetIcon("Node", "EditorIcons");
    }
}
#endif