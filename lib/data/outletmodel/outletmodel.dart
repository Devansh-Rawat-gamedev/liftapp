import '../menudata/menumodel.dart';

class Outlet {
  final String id;
  final String name;
  final String category;
  final List<MenuItem> menu;

  Outlet({
    required this.id,
    required this.name,
    required this.category,
    this.menu = const [],
  });

  factory Outlet.fromMap(String id, Map<String, dynamic> data) {
    return Outlet(
      id: id,
      name: data['name'] ?? '',
      category: data['category'] ?? '',
      menu: (data['menu'] as List<dynamic>? ?? [])
          .map((item) => MenuItem.fromMap(item))
          .toList(),
    );
  }
}
