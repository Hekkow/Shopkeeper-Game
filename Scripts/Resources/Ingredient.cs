using Godot;

[GlobalClass]
public partial class Ingredient : Resource {
	[Export] string name;
	[Export] public Element element;

    public Ingredient() : this("", new Element(0, 0, 0)) { }
    public Ingredient(string name = "", Element element = null)
    {
        this.name = name;
        this.element = element;
    }
    public override bool Equals(object obj)
    {
        if (GetType() != obj.GetType()) return false;
        var castObj = obj as Ingredient;
        return castObj.name == name;
    }
    public static bool operator ==(Ingredient lhs, Ingredient rhs) {
        return lhs.Equals(rhs);
    }
    public static bool operator !=(Ingredient lhs, Ingredient rhs) {
        return !lhs.Equals(rhs);
    }
	public override int GetHashCode() {
        return base.GetHashCode();
    }
	public override string ToString() {
        return name;
    }
}