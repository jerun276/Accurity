/// Represents a single selectable option in a dropdown menu.
class DropdownItem {
  final int? id; // Database ID
  final String
  category; // The dropdown it belongs to (e.g., "PropertyType", "SidingType")
  final String value; // The display value (e.g., "Detached", "Vinyl")

  DropdownItem({this.id, required this.category, required this.value});

  /// Converts this object into a map for SQLite insertion.
  Map<String, dynamic> toMap() {
    return {'id': id, 'category': category, 'value': value};
  }

  /// Creates a DropdownItem from a map retrieved from SQLite.
  factory DropdownItem.fromMap(Map<String, dynamic> map) {
    return DropdownItem(
      id: map['id'],
      category: map['category'],
      value: map['value'],
    );
  }
}
