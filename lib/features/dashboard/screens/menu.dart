import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MenuScreen extends StatelessWidget {
  final String? collegeId;
  final String? campusId;
  final String? outletId;
  final String outletName;
  final List<dynamic>? inlineMenu;

  const MenuScreen({
    Key? key,
    required this.collegeId,
    required this.campusId,
    required this.outletId,
    required this.outletName,
  })  : inlineMenu = null,
        super(key: key);

  MenuScreen.inlineMenu({
    Key? key,
    required this.outletName,
    required List<dynamic> menu,
  })  : collegeId = null,
        campusId = null,
        outletId = null,
        inlineMenu = menu,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    if (inlineMenu != null) {
      return _buildMenuList(context, inlineMenu!);
    }

    if (collegeId == null || campusId == null || outletId == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Menu - $outletName')),
        body: const Center(child: Text('Missing identifiers for Firestore mode.')),
      );
    }

    final outletDocRef = FirebaseFirestore.instance
        .collection('colleges')
        .doc(collegeId)
        .collection('campuses')
        .doc(campusId)
        .collection('outlets')
        .doc(outletId);

    return Scaffold(
      appBar: AppBar(title: Text('Menu - $outletName')),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: outletDocRef.snapshots(),
        builder: (context, outletSnapshot) {
          if (outletSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final outletData = outletSnapshot.data?.data();
          final rawMenuArray = (outletData?['menu'] as List<dynamic>?) ?? [];

          if (rawMenuArray.isNotEmpty) {
            return _buildMenuList(context, rawMenuArray);
          }

          final menuCollectionRef = outletDocRef.collection('menu');
          return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: menuCollectionRef.orderBy('name').snapshots(),
            builder: (context, menuSnapshot) {
              if (menuSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              final docs = menuSnapshot.data?.docs ?? [];
              if (docs.isEmpty) {
                return const Center(child: Text('No menu items available'));
              }
              return _buildMenuList(
                context,
                docs.map((doc) => doc.data()).toList(),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildMenuList(BuildContext context, List<dynamic> menu) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: menu.length,
      itemBuilder: (context, index) {
        final item = (menu[index] as Map?)?.cast<String, dynamic>() ?? {};
        final name = item['name']?.toString() ?? 'Unnamed';
        final price = item['price'];
        final desc = item['description']?.toString() ?? '';
        final isAvailable = item['availability'] != false;

        return Opacity(
          opacity: isAvailable ? 1.0 : 0.5,
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 3,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  if (desc.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4, bottom: 8),
                      child: Text(desc, style: TextStyle(color: Colors.grey[700])),
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _formatPrice(price),
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
                      ),
                      isAvailable
                          ? ElevatedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('$name added to cart')),
                          );
                        },
                        icon: const Icon(Icons.add_shopping_cart),
                        label: const Text("Add to Cart"),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      )
                          : Text(
                        'Not Available',
                        style: TextStyle(color: Colors.red[700], fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _formatPrice(dynamic price) {
    if (price == null) return 'N/A';
    if (price is num) return '₹${price.toStringAsFixed(2)}';
    return price.toString();
  }
}
