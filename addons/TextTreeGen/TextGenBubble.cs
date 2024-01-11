#if TOOLS
using Godot;
using System;
[Tool]
public partial class TextGenBubble : Control
{
    [Signal] public delegate void BubbleRemovedEventHandler(TextGenBubble bubble);
    [Signal] public delegate void BubbleClickedEventHandler(TextGenBubble bubble, Vector2 mousePosition);
    [Signal] public delegate void DraggingStartedEventHandler(TextGenBubble bubble, Vector2 mousePosition);
    [Signal] public delegate void DraggingEndedEventHandler();
    [Signal] public delegate void TextChangedEventHandler();
    public LineEdit lineEdit;
    public TextEdit textEdit;
    bool mouseClicked = true;
    ulong mouseHeldStart = ulong.MaxValue;
    bool dragging = false;

    public override void _Ready()
    {
        lineEdit = GetNode<LineEdit>("MarginContainer/VBoxContainer/LineEdit");
        textEdit = GetNode<TextEdit>("MarginContainer/VBoxContainer/TextEdit");
        lineEdit.TextSubmitted += OnTextChanged;
        textEdit.TextChanged += OnTextChanged;
    }

    void OnTextChanged(string newText)
    {
        EmitSignal(SignalName.TextChanged);
    }

    void OnTextChanged()
    {
        EmitSignal(SignalName.TextChanged);
    }

    public override void _Process(double delta)
    {
        if (Input.IsMouseButtonPressed(MouseButton.Left))
        {
            if (Time.GetTicksMsec() - mouseHeldStart >= 70 && mouseHeldStart != ulong.MaxValue)
            {
                mouseHeldStart = ulong.MaxValue;
                EmitSignal(SignalName.DraggingStarted, this, GetLocalMousePosition());
            }
        }
    }
    public override void _GuiInput(InputEvent @event)
    {
        if (@event is not InputEventMouseButton) return;
        InputEventMouseButton e = (InputEventMouseButton)@event;
        if (e.ButtonIndex == MouseButton.Left)
        {
            if (e.Pressed)
            {
                if (mouseClicked) return;
                EmitSignal(SignalName.BubbleClicked, this, GetLocalMousePosition());
                mouseHeldStart = Time.GetTicksMsec();
                mouseClicked = true;
            }
            else
            {
                mouseClicked = false;
                mouseHeldStart = ulong.MaxValue;
                EmitSignal(SignalName.DraggingEnded);
            }
        }
        else if (e.ButtonIndex == MouseButton.Right && e.Pressed)
        {
            EmitSignal(SignalName.BubbleRemoved, this);
        }
    }

}
#endif