using Godot;

[GlobalClass]
public partial class CharacterStats : Resource {
    [Export] public string name;
    [Export] public Color color;
    public CharacterStats() : this("", new Color(0, 0, 0)) { }
    public CharacterStats(string name, Color color)
    {
        this.name = name;
        this.color = color;
    }
    public override string ToString() {
        return name;
    }
    
    public override bool Equals(object obj)
    {
        if (GetType() != obj.GetType()) return false;
        var castObj = obj as CharacterStats;
        return castObj.name == name;
    }
    public static bool operator ==(CharacterStats lhs, CharacterStats rhs) {
        return lhs.Equals(rhs);
    }
    public static bool operator !=(CharacterStats lhs, CharacterStats rhs) {
        return !lhs.Equals(rhs);
    }
    public override int GetHashCode() {
        return base.GetHashCode();
    }
}