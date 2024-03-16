import 'package:anokha/constants.dart';
import 'package:anokha/utils/toast_message.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CrewPage extends StatefulWidget {
  const CrewPage({super.key});

  @override
  State<CrewPage> createState() => _CrewPageState();
}

class _CrewPageState extends State<CrewPage> {
  bool isLoading = true;

  List<Map<String, dynamic>> crewData = [];

  void _getCrewMembers() async {
    setState(() {
      isLoading = true;
    });

    try {
      final dio = Dio();

      final response = await dio.get(Constants.getCrew,
          options: Options(
            contentType: Headers.jsonContentType,
          ));

      if (response.statusCode == 200) {
        setState(() {
          crewData = List<Map<String, dynamic>>.from(
              response.data["CREW_DATA"] as List<dynamic>);
        });
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
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    _getCrewMembers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print(crewData);
    return Container(
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
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(43, 30, 56, 1),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text('THE CREW',
              style: GoogleFonts.habibi(color: Colors.white, fontSize: 24)),
        ),
        backgroundColor: Colors.transparent,
        body: ListView.builder(
          itemCount: crewData.length,
          itemBuilder: (ctx, i) => Crew(
            crew: crewData[i],
            onTap: () {},
          ),
        ),
      ),
    );
  }
}

class Crew extends StatelessWidget {
  final Map<String, dynamic> crew;
  final VoidCallback onTap;

  const Crew({super.key, required this.crew, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            crew['crewName'].toString(),
            style: GoogleFonts.quicksand(color: Colors.white, fontSize: 24),
          ),
        ),
        const SizedBox(
          height: 24,
        ),
        GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: MediaQuery.of(context).size.width /
                (MediaQuery.of(context).size.height / 2.5),
          ),
          itemCount: crew['teamMembers'].length,
          itemBuilder: (ctx, i) => CrewCard(
            crew: crew['teamMembers'][i],
          ),
        ),
        const SizedBox(
          height: 36,
        )
      ],
    );
  }
}

class CrewCard extends StatelessWidget {
  final Map<String, dynamic> crew;

  const CrewCard({super.key, required this.crew});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 70,
            backgroundImage: NetworkImage(crew['memberImageURL']),
          ),
          Text(
            crew['managerName'],
            style: GoogleFonts.quicksand(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
          Text(
            crew['roleDescription'],
            style: GoogleFonts.quicksand(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
