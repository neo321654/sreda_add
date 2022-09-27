import 'dart:async';

import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import '/new_code/di.dart';

class PurchaseGate extends StatefulWidget {
  final Widget child;
  const PurchaseGate({Key? key, required this.child}) : super(key: key);

  @override
  State<PurchaseGate> createState() => _PurchaseGateState();
}

// TODO: replace with a Cubit
class _PurchaseGateState extends State<PurchaseGate> {
  late final StreamSubscription _subscription;
  @override
  void initState() {
    _subscription = InAppPurchase.instance.purchaseStream.listen(
      (purchases) => purchases.forEach(_handlePurchase),
    );
    super.initState();
  }

  void _handlePurchase(PurchaseDetails purchase) async {
    print("handling purchase: ${purchase.productID} with ${purchase.status}");
    print(purchase.error);
    if (purchase.pendingCompletePurchase) {
      InAppPurchase.instance.completePurchase(purchase);
    }
    if (purchase.status == PurchaseStatus.purchased) {
      final result = await uiDeps.handlePurchase(purchase.productID);
      result.fold(
        (exception) => print(exception),
        (success) => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("OK!", style: TextStyle(color: Colors.white)), backgroundColor: Colors.green),
        ),
      );
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
