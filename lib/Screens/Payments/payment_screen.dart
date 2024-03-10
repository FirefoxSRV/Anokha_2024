import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../Payments/verify_page.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({
    super.key,
    required this.transData,
  });

  final Map<String, dynamic> transData;

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late Map<String, dynamic> payUData;

  final WebViewController _webViewController = WebViewController();

  @override
  void initState() {
    super.initState();
    setState(() {
      payUData = {
        "key": "ypfBaJ",
        "txnid": widget.transData["txnid"],
        "amount": widget.transData["amount"],
        "productinfo": widget.transData["productinfo"],
        "firstname": widget.transData["firstname"],
        "email": widget.transData["email"],
        "phone": widget.transData["phone"],
        "hash": widget.transData["hash"],
        "surl": "https://anokha.amrita.edu/app",
        "furl": "https://anokha.amrita.edu/app",
      };
    });
    _webViewController
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(
        Uri.parse(
          "https://secure.payu.in/_payment",
        ),
        method: LoadRequestMethod.post,
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: Uint8List.fromList(
          payUData.entries
              .map(
                (entry) => "${entry.key}=${entry.value}",
              )
              .join("&")
              .codeUnits,
        ),
      )
      ..setNavigationDelegate(
        NavigationDelegate(onPageStarted: (url) {
          debugPrint(url);
          if (url == payUData["surl"] || url == payUData["furl"]) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => VerifyTransaction(
                  txid: payUData["txnid"],
                ),
              ),
            );
          }
        }),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Make Payment"),
        centerTitle: true,
      ),
      body: WebViewWidget(
        controller: _webViewController,
      ),
    );
  }
}
