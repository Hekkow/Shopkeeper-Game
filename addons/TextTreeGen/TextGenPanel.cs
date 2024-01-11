#if TOOLS
using Godot;
using Godot.Collections;

[Tool]
public partial class TextGenPanel : Control
{
    Array<TextGenBubble> bubbles = new();
    Array<Array<TextGenBubble>> connections = new();
    TextGenBubble draggingBubble;
    Vector2 grabbedFrom;
    TextGenBubble from;
    TextGenBubble to;
    float zoomLevel = 1;
    int n = 0;
    bool panning = false;
    TextTree tree;
    Vector2 panStartPos;
    [Export] LineEdit saveEdit;
    [Export] LineEdit loadEdit;
    string textGenBubblePath = "res://addons/TextTreeGen/TextGenBubble.tscn";
    string savePath = "user://Conversations/";

    public void Reset()
    {
        for (int i = bubbles.Count - 1; i >= 0; i--) bubbles[i].QueueFree();
        bubbles.Clear();
        connections.Clear();
        from = null;
        to = null;
        TreeEdited();
        zoomLevel = 1;
        Scale = new Vector2(zoomLevel, zoomLevel);
        Position = new Vector2(0, 0);
    }
    void OnBubbleRemoved(TextGenBubble bubble)
    {
        bubble.BubbleRemoved -= OnBubbleRemoved;
        bubble.BubbleClicked -= OnBubbleClicked;
        bubble.DraggingStarted -= OnDraggingStarted;
        bubble.DraggingEnded -= OnDraggingEnded;
        bubble.TextChanged -= OnTextChanged;
        bool found = false;
        for (int i = connections.Count - 1; i >= 0; i--)
        {
            if (connections[i].Contains(bubble))
            {
                connections[i].Remove(bubble);
                found = true;
                QueueRedraw();
            }
        }
        TreeEdited();
        if (!found)
        {
            bubbles.Remove(bubble);
            bubble.QueueFree();
        }
    }
    public override void _Ready()
    {
        DelayedSetSize();
    }
    async void DelayedSetSize()
    {
        await ToSignal(GetTree(), "process_frame");
        Size = new Vector2(10000, 10000);
    }

    public override void _Input(InputEvent @event) // MAYBE GO BACK TO INPUT?
    {
        if (@event is InputEventMouseButton) {
            
            InputEventMouseButton e = (InputEventMouseButton)@event;
            if (e.DoubleClick)
            {
                //if get_local_mouse_position().x < 0 || get_local_mouse_position().y < 0 || get_local_mouse_position().x > size.x:
                //    return
                CreateBubble();
            }
            else if (e.ButtonIndex == MouseButton.WheelUp) SetZoom(true);
            else if (e.ButtonIndex == MouseButton.WheelDown) SetZoom(false);
            else if (e.ButtonIndex == MouseButton.Middle)
            {
                if (e.Pressed)
                {
                    panStartPos = GetGlobalMousePosition() - GlobalPosition;
                    panning = true;
                }
                else
                {
                    panning = false;
                }
            }
        }
    }
    void CreateBubble(Vector2 pos = default, string bubbleName="-1", string speaker="", string text = "")
    {
        TextGenBubble textBubble = (TextGenBubble)GD.Load<PackedScene>(textGenBubblePath).Instantiate();
        if (pos == default) textBubble.Position = GetLocalMousePosition() - textBubble.Size / 2;
        else textBubble.Position = pos;
        if (bubbleName == "-1")
        {
            textBubble.Name = n.ToString();
            n++;
        }
        else
        {
            textBubble.Name = bubbleName;
        }
        textBubble.BubbleRemoved += OnBubbleRemoved;
        textBubble.BubbleClicked += OnBubbleClicked;
        textBubble.DraggingStarted += OnDraggingStarted;
        textBubble.DraggingEnded += OnDraggingEnded;
        textBubble.TextChanged += OnTextChanged;
        AddChild(textBubble); // weird order maybe
        textBubble.lineEdit.Text = speaker;
        textBubble.textEdit.Text = text;
        bubbles.Add(textBubble);
    }
    void OnTextChanged()
    {
        TreeEdited();
    }
    void TreeEdited()
    {
        TextGenBubble root = FindRoot();
        GD.Print("sdfiasndif");
        if (root is null) return;
        tree = new TextTree(root.lineEdit.Text, root.textEdit.Text);
        GD.Print("HERE " + root.lineEdit);
        FindBranches(root, tree);
        
    }
    public void SaveFile()
    {
        string genName = saveEdit.Text;
        string fileName = tree.Root().speaker + "-" + genName;
        FileAccess treeFile = FileAccess.Open(savePath + fileName + ".txt", FileAccess.ModeFlags.Write);
        GD.Print("filepath: " + savePath + fileName + ".txt");
        
        treeFile.StoreString(tree.ToString());
        treeFile.Dispose();





        //FileAccess bubblesFile = FileAccess.Open(savePath + fileName + "-gen.txt", FileAccess.ModeFlags.Write);
        //Array<Dictionary> bubblesArr = new();
        //for (int i = 0; i < bubbles.Count; i++)
        //{
        //    bubblesArr.Add(new Dictionary{});
        //    bubblesArr[i]["PositionX"] = bubbles[i].Position.X;
        //    bubblesArr[i]["PositionY"] = bubbles[i].Position.Y;
        //    bubblesArr[i]["Name"] = bubbles[i].Name;
        //    bubblesArr[i]["Speaker"] = bubbles[i].lineEdit;
        //    bubblesArr[i]["Text"] = bubbles[i].textEdit;
        //}
        //bubblesFile.StoreString(Json.Stringify(bubblesArr));
        //bubblesFile.Flush();
        //bubblesFile.Close();
        //FileAccess connectionsFile = FileAccess.Open(savePath + fileName + "-con.txt", FileAccess.ModeFlags.Write);
        //Array<Array<string>> connectionsArr = new();
        //foreach (Array<TextGenBubble> connection in connections)
        //{
        //    connectionsArr.Add(new Array<string>() { connection[0].Name, connection[1].Name });
        //}
        //connectionsFile.StoreString(Json.Stringify(connectionsArr));
        //connectionsFile.Flush();
        //connectionsFile.Close();
    }
    public void LoadFile()
    {
        string genName = loadEdit.Text;
        FileAccess bubblesFile = FileAccess.Open(savePath + genName + "-gen.txt", FileAccess.ModeFlags.Write);
        FileAccess connectionsFile = FileAccess.Open(savePath + genName + "-con.txt", FileAccess.ModeFlags.Write);
        Array<Dictionary> bubblesArr = (Array<Dictionary>)Json.ParseString(bubblesFile.GetAsText());
        Array<Array<string>> connectionsArr = (Array<Array<string>>)Json.ParseString(connectionsFile.GetAsText());
        foreach (Dictionary bubble in bubblesArr)
        {
            CreateBubble(new Vector2((float)bubble["PositionX"], (float)bubble["PositionY"]), (string)bubble["Name"], (string)bubble["Speaker"], (string)bubble["Text"]);
        }
        foreach (Array<string> connection in connectionsArr)
        {
            TextGenBubble from = null;
            TextGenBubble to = null;
            foreach (TextGenBubble bubble in bubbles)
            {
                if (bubble.Name == connection[0]) from = bubble;
                if (bubble.Name == connection[1]) to = bubble;
            }
            connections.Add(new Array<TextGenBubble>() { from, to });
        }
        QueueRedraw();
    }
    void FindBranches(TextGenBubble node, TextTree tree)
    {
        Array<TextGenBubble> branches = new();
        for (int i = 0; i < connections.Count; i++)
        {
            if (connections[i][0] == node)
            {
                branches.Add(connections[i][1]);
            }
        }
        for (int i = 0; i < branches.Count; i++)
        {
            TextTree newTree = tree.Add(node.lineEdit.Text, node.textEdit.Text);
            FindBranches(branches[i], newTree);
        }
    }
    TextGenBubble FindRoot()
    {
        Array<TextGenBubble> trees = new();
        for (int i = 0; i < connections.Count; i++)
        {
            if (!trees.Contains(connections[i][0])) trees.Add(connections[i][0]);
            if (!trees.Contains(connections[i][1])) trees.Add(connections[i][1]);
        }
        for (int i = 0; i < trees.Count; i++)
        {
            bool found = false;
            for (int n = 0; n < connections.Count; n++)
            {
                if (connections[n][1] == trees[i]) found = true;
            }
            if (!found)
            {
                return trees[i];
            }
        }
        return null;
    }
    public override void _Process(double delta)
    {
        if (panning) GlobalPosition = GetGlobalMousePosition() - panStartPos;
        if (draggingBubble is not null)
        {
            draggingBubble.Position = GetLocalMousePosition() - grabbedFrom;
            QueueRedraw();
        }
    }
    void SetZoom(bool zoomIn)
    {
        if (zoomIn) zoomLevel *= 1.05f;
        else zoomLevel /= 1.05f;
        if (zoomLevel < 0.2) zoomLevel = 0.2f;
        Scale = new Vector2(zoomLevel, zoomLevel);
    }
    void OnDraggingStarted(TextGenBubble bubble, Vector2 mousePosition)
    {
        draggingBubble = bubble;
        grabbedFrom = mousePosition;
        from = null;
        to = null;
    }
    void OnDraggingEnded()
    {
        if (draggingBubble is null) return;
        StyleBoxFlat newStyleBox = (StyleBoxFlat)draggingBubble.GetThemeStylebox("panel").Duplicate();
        newStyleBox.BorderWidthTop = 0;
        draggingBubble.AddThemeStyleboxOverride("panel", newStyleBox);
        draggingBubble = null;
    }
    void OnBubbleClicked(TextGenBubble bubble, Vector2 mousePosition)
    {
        if (bubble == to)
        {
            StyleBoxFlat newStyleBox = (StyleBoxFlat)bubble.GetThemeStylebox("panel").Duplicate();
            newStyleBox.BorderWidthTop = 0;
            bubble.AddThemeStyleboxOverride("panel", newStyleBox);
            from = null;
            to = null;
            return;
        }
        else
        {
            StyleBoxFlat newStyleBox = (StyleBoxFlat)bubble.GetThemeStylebox("panel").Duplicate();
            newStyleBox.BorderWidthTop = 3;
            newStyleBox.BorderColor = new Godot.Color(0, 1, 0.5f);
            bubble.AddThemeStyleboxOverride("panel", newStyleBox);
        }
        from = to;
        to = bubble;
        if (from is null) return;
        bool found = false;
        for (int i = 0; i < connections.Count; i++)
        {
            if (connections[i].Contains(from) && connections[i].Contains(to)) {
                found = true;
                connections[i] = new Array<TextGenBubble>() { connections[i][1], connections[i][0] };
            }
        }
        StyleBoxFlat styleBox = (StyleBoxFlat)bubble.GetThemeStylebox("panel").Duplicate();
        styleBox.BorderWidthTop = 0;
        from.AddThemeStyleboxOverride("panel", styleBox);
        to.AddThemeStyleboxOverride("panel", styleBox);
        if (!found) connections.Add(new Array<TextGenBubble>() { from, to });
        TreeEdited();
        from = null;
        to = null;
        QueueRedraw();
    }
    public override void _Draw()
    {
        foreach (Array<TextGenBubble> connection in connections) {
            Array<Vector2> corners = ClosestCorners(connection[0], connection[1]);
            DrawLine(corners[0], corners[1], new Godot.Color(0, 1, 0), 3);
            DrawCircle(corners[1], 5, new Godot.Color(0, 1, 0));
        }
    }
    Array<Vector2> GetCorners(TextGenBubble box)
    {
        Array<Vector2> corners = new();
        corners.Add(box.Position);
        corners.Add((box.Position + new Vector2(box.Size.X / 2 * zoomLevel, 0)));
        corners.Add((box.Position + new Vector2(box.Size.X * zoomLevel, 0)));
        corners.Add((box.Position + new Vector2(box.Size.X * zoomLevel, box.Size.Y / 2 * zoomLevel)));
        corners.Add((box.Position + box.Size * zoomLevel));
        corners.Add((box.Position + new Vector2(box.Size.X / 2 * zoomLevel, box.Size.Y * zoomLevel)));
        corners.Add((box.Position + new Vector2(0, box.Size.Y * zoomLevel)));
        corners.Add((box.Position + new Vector2(0, box.Size.Y / 2 * zoomLevel)));
        return corners;
    }
    Array<Vector2> GetCornersFrom(TextGenBubble box)
    {
        Array<Vector2> corners = new();
        corners.Add((box.Position + new Vector2(box.Size.X / 2 * zoomLevel, 0)));
        corners.Add((box.Position + new Vector2(box.Size.X * zoomLevel, box.Size.Y / 2 * zoomLevel)));
        corners.Add((box.Position + new Vector2(box.Size.X / 2 * zoomLevel, box.Size.Y * zoomLevel)));
        corners.Add((box.Position + new Vector2(0, box.Size.Y / 2 * zoomLevel)));
        return corners;
    }
    Array<Vector2> ClosestCorners(TextGenBubble from, TextGenBubble to)
    {
        float smallestDistance = 1000000;
        Vector2 smallestFrom = Vector2.Inf;
        Vector2 smallestTo = Vector2.Inf;
        foreach (Vector2 cornerFrom in GetCornersFrom(from))
        {
            foreach (Vector2 cornerTo in GetCorners(to)) {
                if (cornerFrom.DistanceTo(cornerTo) < smallestDistance)
                {
                    smallestDistance = cornerFrom.DistanceTo(cornerTo);
                    smallestFrom = cornerFrom;
                    smallestTo = cornerTo;
                }
            }
        }
        return new Array<Vector2>() { smallestFrom, smallestTo };
    }
}
#endif