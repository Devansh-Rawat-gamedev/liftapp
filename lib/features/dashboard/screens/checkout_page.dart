import 'package:flutter/material.dart';
import 'package:upi_india/upi_india.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CheckoutPage extends StatefulWidget {
  final double totalAmount;
  final List<Map<String, dynamic>> cartItems;
  final String collegeId;
  final String outletId;

  const CheckoutPage({
    super.key,
    required this.totalAmount,
    required this.cartItems,
    required this.collegeId,
    required this.outletId,
  });

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final UpiIndia _upiIndia = UpiIndia();
  List<UpiApp>? apps;
  bool _isLoading = true;
  Map<String, dynamic>? _upiConfig;
  String? _paymentStatus;

  @override
  void initState() {
    super.initState();
    _fetchUpiConfig();
  }

  Future<void> _fetchUpiConfig() async {
    final doc = await FirebaseFirestore.instance
        .collection('colleges')
        .doc(widget.collegeId)
        .collection('outlets')
        .doc(widget.outletId)
        .collection('payment_gateways')
        .doc('upi')
        .get();

    if (doc.exists && doc.data()?['isEnabled'] == true) {
      setState(() {
        _upiConfig = doc.data();
      });
      await _fetchUpiApps();
    } else {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("UPI payment not available for this outlet")),
        );
      }
    }
  }

  Future<void> _fetchUpiApps() async {
    try {
      final appsList = await _upiIndia.getAllUpiApps(mandatoryTransactionId: false);
      setState(() {
        apps = appsList;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        apps = [];
        _isLoading = false;
      });
    }
  }

  void _startTransaction(UpiApp app) async {
    if (_upiConfig == null) return;

    final transactionRef = "ORDER${DateTime.now().millisecondsSinceEpoch % 100000}";

    UpiResponse response = await _upiIndia.startTransaction(
      app: app,
      receiverUpiId: _upiConfig!['upiId'],
      receiverName: _upiConfig!['name'],
      transactionRefId: transactionRef,
      transactionNote: "Payment for your order",
      amount: widget.totalAmount,
    );

    if (!mounted) return;

    setState(() {
      _paymentStatus = response.status.toString();
    });

    if (response.status == UpiPaymentStatus.SUCCESS) {
      // Get current user ID from FirebaseAuth
      final user = FirebaseAuth.instance.currentUser;
      final userId = user?.uid ?? 'anonymous';

      await FirebaseFirestore.instance.collection('orders').add({
        'token': transactionRef,
        'customerId': userId,
        'outletId': widget.outletId,
        'items': widget.cartItems,
        'totalAmount': widget.totalAmount,
        'paymentId': response.transactionId,
        'status': 'pending',
        'timestamp': FieldValue.serverTimestamp(),
        'paymentMethod': 'UPI - ${app.name}',
      });

      if (mounted) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Payment Successful 🎉"),
            content: Text("Your order token number is: $transactionRef"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text("OK"),
              ),
            ],
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Payment failed or cancelled")),
      );
    }
  }

  String get _upiQrCodeData {
    print("UPI QR Code data: $_upiQrCodeData");

    if (_upiConfig == null) return "";
    return Uri(
      scheme: 'upi',
      host: 'pay',
      queryParameters: {
        'pa': _upiConfig!['upiId'],
        'pn': _upiConfig!['name'],
        'am': widget.totalAmount.toStringAsFixed(2),
        'cu': 'INR',
        'tn': 'Payment for your order',
      },
    ).toString();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_upiConfig == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Checkout")),
        body: const Center(child: Text("UPI payment configuration not found.")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Checkout")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: widget.cartItems.map((item) {
                  return ListTile(
                    title: Text(item['name']),
                    trailing: Text("₹${item['price']} × ${item['quantity']}"),
                  );
                }).toList(),
              ),
            ),
            Text(
              "Total: ₹${widget.totalAmount.toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (apps != null && apps!.isNotEmpty) ...[
              const Text(
                "Select a UPI app to pay:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                children: apps!.map((app) {
                  return ElevatedButton.icon(
                    icon: Image.memory(
                      app.icon,
                      width: 24,
                      height: 24,
                    ),
                    label: Text(app.name),
                    onPressed: () => _startTransaction(app),
                  );
                }).toList(),
              ),
            ] else ...[
              const Text(
                "No UPI apps found on your device.",
                style: TextStyle(fontSize: 16, color: Colors.red),
              ),
              const SizedBox(height: 24),
              const Text(
                "Scan this QR code with your UPI app to pay:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              Center(
                child: QrImageView(
                  data: _upiQrCodeData,
                  version: QrVersions.auto,
                  size: 200.0,
                ),
              ),
            ],
            if (_paymentStatus != null) ...[
              const SizedBox(height: 16),
              Text(
                "Payment Status: $_paymentStatus",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
