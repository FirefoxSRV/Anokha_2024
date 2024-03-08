
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Utils/MyDelightToastBar.dart';
import '../../../constants.dart';
import '../../../utils/loading_component.dart';
import '../../Auth/primary_page.dart';
import '../../Payments/verify_page.dart';

class ViewTransactions extends StatefulWidget {
  const ViewTransactions({super.key});

  @override
  State<ViewTransactions> createState() => _ViewTransactionsState();
}

class _ViewTransactionsState extends State<ViewTransactions> {
  List<Map<String, dynamic>> _transactionData = [];
  bool _isLoading = true;

  void _getAllTransactions() async {
    setState(() {
      _isLoading = true;
    });

    final sp = await SharedPreferences.getInstance();

    if (sp.getString("TOKEN")!.isEmpty) {
      _logOut();
      return;
    }

    try {
      final dio = Dio();

      final response = await dio.get(Constants.getAlltransactions,
          options: Options(
            contentType: Headers.jsonContentType,
            headers: {"Authorization": "Bearer ${sp.getString("TOKEN")}"},
          ));

      if (response.statusCode == 200) {
        setState(() {
          _transactionData = List<Map<String, dynamic>>.from(
              response.data["PAY_U_TRANSACTIONS"] as List<dynamic>);
        });
      } else if (response.statusCode == 401) {
        _logOut();
      } else if (response.statusCode == 400) {
        showToast(response.data["MESSAGE"] ??
            "Something Went Wrong. We're working on it. Please try Again later.");
      } else {
        showToast(
            "Something Went Wrong. We're working on it. Please try Again later.");
      }
    } catch (e) {
      debugPrint(e.toString());

      showToast(
          "Something Went Wrong. We're working on it. Please try Again later.");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    _getAllTransactions();
  }

  Widget transactionHistoryCard(int index) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            dense: true,
            title: Text(
              "₹ ${_transactionData[index]["amount"].toString()}",
              style: GoogleFonts.poppins(
                textStyle: Theme.of(context).textTheme.titleMedium,
                color: Colors.white,
              ),
              textAlign: TextAlign.start,
            ),
            subtitle: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat('EEE, MMM d, ' 'yy').format(DateTime.parse(
                      _transactionData[index]["timeOfTransaction"])),
                  style: GoogleFonts.poppins(
                    textStyle: Theme.of(context).textTheme.bodySmall,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.start,
                ),
                Text(
                  DateFormat('h:MM a').format(DateTime.parse(
                      _transactionData[index]["timeOfTransaction"])),
                  style: GoogleFonts.poppins(
                    textStyle: Theme.of(context).textTheme.bodySmall,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.start,
                )
              ],
            ),
            trailing: _transactionData[index]['transactionStatus'] == "0"
                ? InkWell(
                    onTap: () {
                      Navigator.pushReplacement(
                          context, MaterialPageRoute(builder: (context) => VerifyTransaction(
                          txid: _transactionData[index]['txnId'])));

                    },
                    child: Chip(
                      avatar: const Icon(
                        Icons.sim_card_alert_rounded,
                        color: Colors.orange,
                      ),
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      side: const BorderSide(
                        color: Colors.orange,
                      ),
                      padding: const EdgeInsets.all(4.0),
                      label: Text(
                        "Verify Now",
                        style: GoogleFonts.nunito(
                          textStyle: Theme.of(context).textTheme.bodyMedium,
                          fontWeight: FontWeight.w600,
                          color: Colors.deepOrangeAccent,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      backgroundColor: Colors.orangeAccent.withOpacity(0.3),
                    ),
                  )
                : Chip(
                    avatar: _transactionData[index]['transactionStatus'] == '1'
                        ? const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                          )
                        : const Icon(Icons.not_interested_rounded,
                            color: Colors.red),
                    elevation: 1,
                    color: MaterialStateProperty.all(
                        _transactionData[index]['transactionStatus'] == '1'
                            ? Colors.lightGreenAccent.withOpacity(0.2)
                            : Colors.redAccent.withOpacity(0.2)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    side: BorderSide(
                      color: _transactionData[index]['transactionStatus'] == '1'
                          ? Colors.green
                          : Colors.red,
                    ),
                    padding: const EdgeInsets.all(4.0),
                    label: Text(
                      _transactionData[index]['transactionStatus'] == '1'
                          ? "Success"
                          : "Failure",
                      style: GoogleFonts.nunito(
                        textStyle: Theme.of(context).textTheme.bodyMedium,
                        fontWeight: FontWeight.w600,
                        color:
                            _transactionData[index]['transactionStatus'] == '1'
                                ? Colors.green
                                : Colors.red,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
          ),
        ),
        Divider(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(43, 30, 56, 1),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
        title: Text(
          "Transaction History",
          style: GoogleFonts.habibi(
            textStyle: TextStyle(color: Colors.white),
          ),
        ),
      ),
      body: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height,
        ),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromRGBO(43, 30, 56, 1),
                Color.fromRGBO(11, 38, 59, 1),
                Color.fromRGBO(15, 21, 39, 1),
              ],
            ),
          ),
          child: _isLoading == true
              ? const LoadingComponent()
              : SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 16,
                      ),
                      if (_transactionData.isEmpty) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 16.0,
                            horizontal: 16.0,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .errorContainer
                                .withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "No transactions yet.",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.nunito(
                                  textStyle:
                                      Theme.of(context).textTheme.titleSmall,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ] else ...[
                        ListView.builder(
                          itemCount: _transactionData.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 0.0,
                            vertical: 16.0,
                          ),
                          itemBuilder: (context, index) {
                            return transactionHistoryCard(index);
                          },
                        ),
                      ],
                    ],
                  ),
                ),
        ),
      ),
    );
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
        context, MaterialPageRoute(builder: (context) =>  const PrimaryScreen()),(route)=>false);
  }
}
