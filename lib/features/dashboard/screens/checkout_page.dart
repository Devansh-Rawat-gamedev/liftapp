import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
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
  late Razorpay _razorpay;
  bool _loading = true;
  String? _paymentStatus;
  String? _keyId;
  String? _merchantName;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    _fetchRazorpayConfig();
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  Future<void> _fetchRazorpayConfig() async {
    setState(() {
      _loading = true;
    });

    final doc = await FirebaseFirestore.instance
        .collection('colleges')
        .doc(widget.collegeId)
        .collection('outlets')
        .doc(widget.outletId)
        .collection('payment_gateways')
        .doc('razorpay')
        .get();

    if (doc.exists && doc.data()?['isEnabled'] == true) {
      final data = doc.data()!;
      setState(() {
        _keyId = data['keyId'];
        _merchantName = data['merchantName'] ?? 'Your Business Name';
        _loading = false;
      });
    } else {
      setState(() {
        _loading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Razorpay payment not available for this outlet")),
        );
      }
    }
  }

  void _openCheckout() {
    if (_keyId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Payment configuration missing.")),
      );
      return;
    }

    final options = {
      'key': _keyId!,
      'amount': (widget.totalAmount * 100).toInt(), // in paise
      'name': _merchantName ?? 'Your Business',
      'description': 'Payment for your order',
      'prefill': {
        'contact': FirebaseAuth.instance.currentUser?.phoneNumber ?? '',
        'email': FirebaseAuth.instance.currentUser?.email ?? '',
      },
      'external': {
        'wallets': ['paytm']
      },
      'theme': {
        'color': '#F37254',
      },
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error opening payment gateway: $e")),
      );
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    setState(() {
      _paymentStatus = "SUCCESS";
    });

    final user = FirebaseAuth.instance.currentUser;
    final userId = user?.uid ?? 'anonymous';

    await FirebaseFirestore.instance.collection('orders').add({
      'customerId': userId,
      'outletId': widget.outletId,
      'items': widget.cartItems,
      'totalAmount': widget.totalAmount,
      'paymentStatus': 'success',
      'razorpayPaymentId': response.paymentId,
      'timestamp': FieldValue.serverTimestamp(),
      'paymentMethod': 'Razorpay',
    });

    if (!mounted) return;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Payment Successful 🎉"),
        content: const Text("Thank you for your payment."),
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

  void _handlePaymentError(PaymentFailureResponse response) {
    setState(() {
      _paymentStatus = "FAILED";
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Payment failed: ${response.message}")),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("External wallet selected: ${response.walletName}")),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_keyId == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Checkout")),
        body: const Center(child: Text("Razorpay payment configuration not found.")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Checkout")),
      body: Padding(
        padding: const EdgeInsets.all(16),
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
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _openCheckout,
              child: const Text("Pay Now"),
            ),
            if (_paymentStatus != null) ...[
              const SizedBox(height: 20),
              Text(
                "Payment Status: $_paymentStatus",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
