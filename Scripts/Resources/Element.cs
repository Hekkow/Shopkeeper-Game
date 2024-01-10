using Godot;
using Godot.Collections;
[GlobalClass]
public partial class Element : Resource {
	[Export] int a;
	[Export] int b;
	[Export] int c;
	string[] elementNames = {"A", "B", "C"};

	static readonly int numberElements = 3;
	int fillPercent = 75;
    public Element() : this(0, 0, 0) { }
    public Element(int _a=0, int _b=0, int _c=0) {
		a = _a;
		b = _b;
		c = _c;
	}
	public int[] GetArr() {
		int[] arr = {a, b, c};
		return arr;
	}
	public override bool Equals(object obj)
    {
        if (GetType() != obj.GetType()) return false;
        var castObj = obj as Element;
        return castObj.a == a && castObj.b == b && castObj.c == c;
    }
    public static bool operator ==(Element lhs, Element rhs) {
        return lhs.Equals(rhs);
    }
    public static bool operator !=(Element lhs, Element rhs) {
        return !lhs.Equals(rhs);
    }
    public override int GetHashCode() {
        return base.GetHashCode();
    }
	public static Element IngredientToElement(Array<InventorySlot> inventorySlots) {
		var element = new Element();
		for (int i  = 0; i < inventorySlots.Count; i++) {
			for (int j = 0; j < numberElements; j++) {
				element.Add(j, ((Ingredient)inventorySlots[i].obj).element.GetArr()[j] * inventorySlots[i].amount);
			}
		}
		return element;
	}
	public void Add(int index, int value) {
		switch(index) {
			case 0:
				a += value;
				break;
			case 1:
				b += value;
				break;
			case 2:
				c += value;
				break;
		}
	}
	public Array<int> ElementToPercentages() {
		Array<int> percentages = new();
		int maximum = GetMax();
		int[] elements = GetArr();
		for (int i = 0; i < numberElements; i++) {
			percentages.Add((int)((float)elements[i]/maximum*fillPercent));
		}
		return percentages;
	}
	public int GetMax() {
		int[] elements = GetArr();
		int maximum = 0;
		for (int i = 0; i < numberElements; i++) {
			if (elements[i] > maximum) {
				maximum = elements[i];
			}
		}
		return maximum;
	}
	public override string ToString() {
        return $"{elementNames[0]}: {a}, {elementNames[1]}: {b}, {elementNames[2]}: {c}";
    }
}
