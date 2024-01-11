using Godot;
using Godot.Collections;

[GlobalClass]
public partial class Recipe : Resource {
	[Export] public string name;
	[Export] Element element;
	[Export] public int basePrice;
	double maxDiff = 0.2;
	public override bool Equals(object obj)
    {
		if (obj is null) return false;
		if (obj is Recipe) {
			Recipe castObj = (Recipe)obj;
			return castObj.name == name;
		}
		if (obj is Array<int>) {
			for (int i = 0; i < element.GetArr().Length; i++) {
				if (Mathf.Abs(element.GetArr()[i] - ((Array<int>)obj)[i]) > maxDiff) {
					return false;
				}
			}
			return true;
		}
		return false;
    }
    public static bool operator ==(Recipe lhs, Recipe rhs) => lhs.Equals(rhs);
    public static bool operator !=(Recipe lhs, Recipe rhs) => !lhs.Equals(rhs);
	public static bool operator ==(Recipe lhs, Array<int> rhs) => lhs.Equals(rhs);
    public static bool operator !=(Recipe lhs, Array<int> rhs) => !lhs.Equals(rhs);
    public static bool operator ==(Recipe lhs, object rhs) => false;
    public static bool operator !=(Recipe lhs, object rhs) => true;
    public override int GetHashCode() => base.GetHashCode();
	public override string ToString() => name;
}

