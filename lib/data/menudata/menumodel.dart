class MenuItem {
  final String name;
  final double price;
  final String description;
  final bool isAvailable;

  MenuItem({
    required this.name,
    required this.price,
    required this.description,
    required this.isAvailable,
  });

  factory MenuItem.fromMap(Map<String, dynamic> map) {
    return MenuItem(
      name: map['name'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      description: map['description'] ?? '',
      isAvailable: map['availability'] != false,
    );
  }
}
