import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb, defaultTargetPlatform;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pay/pay.dart';
import 'dart:html' as html;

class CheckoutPage extends StatefulWidget {
  final String collegeId;
  final String campusId;
  final String outletId;
  final List<Map<String, dynamic>> cartItems;

  const CheckoutPage({
    super.key,
    required this.collegeId,
    required this.campusId,
    required this.outletId,
    required this.cartItems,
  });

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  bool _loading = true;
  String? _paymentStatus;
  String? _merchantName;
  double _totalAmount = 0;

  List<PaymentItem> _paymentItems = [];

  String? _googlePayConfigJson;
  String? _applePayConfigJson;

  @override
  void initState() {
    super.initState();
    _calculateTotalAmount();
    _fetchPaymentConfig();
  }

  void _calculateTotalAmount() {
    double sum = 0;
    for (var item in widget.cartItems) {
      sum += (item['price'] as num) * (item['quantity'] as num);
    }
    _totalAmount = sum;

    _paymentItems = [
      PaymentItem(
        label: 'Total',
        amount: _totalAmount.toStringAsFixed(2),
        status: PaymentItemStatus.final_price,
      ),
    ];
  }

  Future<void> _fetchPaymentConfig() async {
    setState(() => _loading = true);

    try {
      final doc = await FirebaseFirestore.instance
          .collection('colleges')
          .doc(widget.collegeId)
          .collection('campuses')
          .doc(widget.campusId)
          .collection('outlets')
          .doc(widget.outletId)
          .collection('payment_gateway')
          .doc('google_apple_pay')
          .get();

      if (doc.exists && doc.data()?['isEnabled'] == true) {
        final data = doc.data()!;
        _merchantName = data['merchantName'] ?? "Merchant";

        final googlePayConfigMap = {
          "apiVersion": 2,
          "apiVersionMinor": 0,
          "allowedPaymentMethods": [
            {
              "type": "CARD",
              "parameters": {
                "allowedAuthMethods": List<String>.from(
                    data['allowedAuthMethods'] ??
                        ['PAN_ONLY', 'CRYPTOGRAM_3DS']),
                "allowedCardNetworks": List<String>.from(
                    data['allowedCardNetworks'] ??
                        ['VISA', 'MASTERCARD', 'AMEX']),
              },
              "tokenizationSpecification": {
                "type": "PAYMENT_GATEWAY",
                "parameters": {
                  "gateway": data['gateway'] ?? "example",
                  "gatewayMerchantId":
                  data['gatewayMerchantId'] ?? "exampleMerchantId",
                }
              }
            }
          ],
          "merchantInfo": {
            "merchantId": data['merchantId'] ?? "",
            "merchantName": _merchantName,
          },
          "transactionInfo": {
            "countryCode": data['countryCode'] ?? "IN",
            "currencyCode": data['currencyCode'] ?? "INR",
            "totalPriceStatus": "FINAL",
            "totalPrice": _totalAmount.toStringAsFixed(2),
          }
        };

        final applePayConfigMap = {
          "provider": "apple_pay",
          "data": {
            "merchantIdentifier":
            data['appleMerchantIdentifier'] ?? "merchant.com.example",
            "displayName": _merchantName,
            "merchantCapabilities": List<String>.from(
                data['appleMerchantCapabilities'] ??
                    ["3DS", "debit", "credit"]),
            "supportedNetworks": List<String>.from(
                data['appleSupportedNetworks'] ??
                    ["amex", "visa", "masterCard"]),
            "countryCode": data['countryCode'] ?? "IN",
            "currencyCode": data['currencyCode'] ?? "INR"
          }
        };

        setState(() {
          _googlePayConfigJson = jsonEncode(googlePayConfigMap);
          _applePayConfigJson = jsonEncode(applePayConfigMap);
          _loading = false;
        });
      } else {
        setState(() {
          _loading = false;
          _merchantName = null;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text("Payment not enabled for this outlet")),
          );
        }
      }
    } catch (e) {
      setState(() => _loading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error fetching payment config: $e")),
        );
      }
    }
  }

  void _onPaymentResult(Map<String, dynamic> paymentResult) async {
    setState(() {
      _paymentStatus = "SUCCESS";
    });

    final user = FirebaseAuth.instance.currentUser;
    final userId = user?.uid ?? 'anonymous';

    try {
      await FirebaseFirestore.instance.collection('orders').add({
        'customerId': userId,
        'collegeId': widget.collegeId,
        'campusId': widget.campusId,
        'outletId': widget.outletId,
        'items': widget.cartItems,
        'totalAmount': _totalAmount,
        'paymentStatus': 'success',
        'paymentDetails': paymentResult,
        'timestamp': FieldValue.serverTimestamp(),
        'paymentMethod': kIsWeb
            ? 'Web Checkout'
            : defaultTargetPlatform.name == 'android'
            ? 'Google Pay'
            : 'Apple Pay',
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
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to save order: $e")),
        );
      }
    }
  }

  void _onPaymentError(Object? error) {
    setState(() {
      _paymentStatus = "FAILED";
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Payment failed: $error")),
      );
    }
  }

  Widget _buildPaymentButton() {
    if (_googlePayConfigJson == null || _applePayConfigJson == null) {
      return const Text('Payment configuration missing.');
    }

    if (kIsWeb) {
      return ElevatedButton(
        onPressed: () {
          final hostedUrl =
              "https://your-payment-link.com?amount=$_totalAmount";
          html.window.open(hostedUrl, "_blank");
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        ),
        child: Text(
          "Pay ₹${_totalAmount.toStringAsFixed(2)} (Web Checkout)",
          style: const TextStyle(fontSize: 16, color: Colors.white),
        ),
      );
    }

    else if (defaultTargetPlatform == TargetPlatform.android) {
      return GooglePayButton(
        paymentConfiguration:
        PaymentConfiguration.fromJsonString(_googlePayConfigJson!),
        paymentItems: _paymentItems,
        type: GooglePayButtonType.pay,
        onPaymentResult: _onPaymentResult,
        loadingIndicator: const CircularProgressIndicator(),
        onError: _onPaymentError,
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return ApplePayButton(
        paymentConfiguration:
        PaymentConfiguration.fromJsonString(_applePayConfigJson!),
        paymentItems: _paymentItems,
        type: ApplePayButtonType.buy,
        onPaymentResult: _onPaymentResult,
        loadingIndicator: const CircularProgressIndicator(),
        onError: _onPaymentError,
      );
    } else {
      return const Text('Payment not supported on this platform');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_merchantName == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Checkout")),
        body: const Center(
            child: Text("Payment configuration not found or disabled.")),
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
                    trailing: Text(
                        "₹${item['price']} × ${item['quantity']}"),
                  );
                }).toList(),
              ),
            ),
            Text(
              "Total: ₹${_totalAmount.toStringAsFixed(2)}",
              style: const TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildPaymentButton(),
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
