
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants.dart';
import '../Auth/primary_page.dart';
import 'Payment_Utils/Verification/paymentFailed.dart';
import 'Payment_Utils/Verification/paymentPending.dart';
import 'Payment_Utils/Verification/paymentSuccess.dart';
import 'Payment_Utils/Verification/verifyingScreen.dart';


class VerifyTransaction extends StatefulWidget {
  String txid;

   VerifyTransaction({super.key,required this.txid}){
     txid=this.txid;
   }

  @override
  State<VerifyTransaction> createState() => _VerifyTransactionState();
}

class _VerifyTransactionState extends State<VerifyTransaction> {
  bool _verifying=false;
  void initState() {
    super.initState();
    _verifyTransaction(widget.txid);

  }
  @override
  Widget build(BuildContext context) {
    return Verifying(txnId: widget.txid,);
  }

  void _logOut() {
    //clearing the cache
    SharedPreferences.getInstance().then((sp) {
      sp.setBool("LOGGEDINKEY", false);
      sp.setString("NAME", "");
      sp.setString("EMAIL", "");
      sp.setString("PHONE", "");
      sp.setString("COLLEGE", "");
      sp.setString("CITY", "");
      sp.setString("TOKEN", "");
    });
    Navigator.pushAndRemoveUntil(
        context, MaterialPageRoute(builder: (context) => const PrimaryScreen()),(route)=>false);

  }
  void _verifyTransaction(String transactionId) async{
    String? secretToken = "";

    try {
      SharedPreferences.getInstance().then((sp) async {
        setState(() {
          secretToken = sp.getString("TOKEN");
        });

        final response = await Dio().post(
          Constants.verifyTransaction,
          options: Options(
            headers: {
              "Authorization": "Bearer ${secretToken}",
            },
            validateStatus: (status) => status! < 1000,
          ),
          data: {
            "transactionId": transactionId
          },
        );
        if (kDebugMode) {
          print("[Transaction Verification]: ${response.data}");
          print("[STATUS]: ${response.statusCode}");
        }
        if (response.statusCode == 200) {
          showToast("Transaction Successful");
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => const PaymentSuccess()));
        }
        else if(response.statusCode == 201){
          showToast("Transaction Pending");
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => const PaymentPending()));
        }
        else if (response.statusCode == 202) {
          showToast("Transaction Failed");
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => const PaymentFailed()));
        }
        else if (response.statusCode == 400 && response.data["MESSAGE"] != null) {
          showToast(response.data["MESSAGE"]);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Verifying(txnId: widget.txid,)));
        } else if (response.statusCode == 401) {
          showToast("Session Expired. Please Login again.");
          // User was logged in. But Session Expired. Handle it. Navigate back to LoginScreen
          _logOut();
        } else {
          // Some unknown error. Handle It
          showToast("Something went wrong please wait");
          Navigator.pushAndRemoveUntil(
              context, MaterialPageRoute(builder: (context) => const PrimaryScreen()),(route)=>false);

        }
      });
    } catch (err) {
      // Something went wrong. Unknown Error. Handle It.
      showToast(err.toString());
    }
  }

  void showToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        timeInSecForIosWeb: 1,
        fontSize: 16.0
    );
  }
}
