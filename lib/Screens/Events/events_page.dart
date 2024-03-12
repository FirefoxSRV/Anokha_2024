import 'dart:math';

import 'package:anokha/Screens/Auth/primary_page.dart';
import 'package:anokha/Screens/Events/specific_event.dart';
import 'package:anokha/constants.dart';
import 'package:anokha/utils/loading_component.dart';
import 'package:anokha/utils/toast_message.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EventsWorkshopsPage extends StatefulWidget {
  final bool isFeatured;

  const EventsWorkshopsPage({super.key, required this.isFeatured});

  @override
  EventsWorkshopsPageState createState() => EventsWorkshopsPageState();
}

class EventsWorkshopsPageState extends State<EventsWorkshopsPage> {
  bool _isLoading = false;

  // final String _selectedDepartment = '';
  List<Map<String, dynamic>> _filteredEvents = [], eventData = [];
  bool _isSearching = false;
  final TextEditingController _searchQueryController = TextEditingController();

  List<Map<String, dynamic>> tagData = [];
  List<Map<String, dynamic>> selectedTags = [];

  bool _isWorkshop = false;
  bool _isEvent = false;
  bool _isTechnical = false;
  bool _isNonTechnical = false;
  bool _isGroup = false;
  bool _isIndividual = false;
  bool _isStarred = false;

  @override
  void initState() {
    super.initState();
    _getAllEvents();
    _getAllTags();
  }

  @override
  void dispose() {
    _searchQueryController.dispose();
    super.dispose();
  }

  void _getAllEvents() async {
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

      final response = await dio.get(Constants.getallEvents,
          options: Options(
              contentType: Headers.jsonContentType,
              headers: {"Authorization": "Bearer ${sp.getString("TOKEN")}"}));

      if (response.statusCode == 200) {
        if (widget.isFeatured == true) {
          List<Map<String, dynamic>> allEventData = [], featuredEventData = [];

          allEventData = List<Map<String, dynamic>>.from(
              response.data["EVENTS"] as List<dynamic>);

          for (int i = 0; i < allEventData.length; i++) {
            bool flag = false;

            for (int j = 0; j < allEventData[i]["tags"].length; j++) {
              if (allEventData[i]["tags"][j]["tagAbbreviation"] == "FT.") {
                flag = true;
                break;
              }
            }

            if (flag == true) {
              featuredEventData.add(allEventData[i]);
            }
          }

          setState(() {
            eventData = featuredEventData;
            _filteredEvents = featuredEventData;
          });
        } else {
          setState(() {
            _filteredEvents = List<Map<String, dynamic>>.from(
                response.data["EVENTS"] as List<dynamic>);
            eventData = List<Map<String, dynamic>>.from(
                response.data["EVENTS"] as List<dynamic>);
          });
        }
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

  void _getAllTags() async {
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

      final response = await dio.get(Constants.getAllTags,
          options: Options(
            contentType: Headers.jsonContentType,
          ));

      if (response.statusCode == 200) {
        final List<Map<String, dynamic>> tempTagData =
            List<Map<String, dynamic>>.from(
                response.data["tags"] as List<dynamic>);

        for (int i = 0; i < tempTagData.length; i++) {
          setState(() {
            tagData.add({
              "tagName": tempTagData[i]["tagName"],
              "tagAbbreviation": tempTagData[i]["tagAbbreviation"]
            });
          });
        }

        setState(() {
          selectedTags = [];
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

  void _handleFilters() {
    final events = eventData;
    setState(() {
      _isLoading = true;
    });

    debugPrint(events[0]["isStarred"].toString());

    final filteredEvents = events
        .where((event) => ((_isWorkshop ? event['isWorkshop'] == "1" : true) &&
            (_isEvent ? event['isWorkshop'] == "0" : true) &&
            (_isTechnical ? event['isTechnical'] == "1" : true) &&
            (_isNonTechnical ? event['isTechnical'] == "0" : true) &&
            (_isGroup ? event['isGroup'] == "1" : true) &&
            (_isStarred
                ? (event['isStarred'].toString() == 'null' ||
                    event['isStarred'] == '1')
                : true) &&
            (_isIndividual ? event['isGroup'] == "0" : true) &&
            (selectedTags.isEmpty ||
                event['tags'].any((e) => selectedTags
                    .any((element) => element["tagName"] == e["tagName"])))))
        .toList();

    setState(() {
      _filteredEvents = filteredEvents;
      _isLoading = false;
    });
  }

  void _handleSearch(String query) {
    setState(() {
      _isSearching = true;
    });

    final events = eventData;
    if (query.isNotEmpty) {
      final filteredEvents = events.where((event) {
        return event["eventName"].toLowerCase().contains(query.toLowerCase()) ||
            event['eventDescription']
                .toLowerCase()
                .contains(query.toLowerCase());
      }).toList();

      setState(() {
        _filteredEvents = filteredEvents;
      });
    } else {
      setState(() {
        _filteredEvents = events;
      });
    }
  }

  void _updateFilterStates(bool isEvent, bool isWorkshop, bool isTechnical,
      bool isNonTechnical, bool isGroup, bool isIndividual, bool isStarred) {
    setState(() {
      _isEvent = isEvent;
      _isWorkshop = isWorkshop;
      _isTechnical = isTechnical;
      _isNonTechnical = isNonTechnical;
      _isGroup = isGroup;
      _isIndividual = isIndividual;
      _isStarred = isStarred;
      _handleFilters();
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _pullRefresh,
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
        child: Scaffold(
          backgroundColor: Colors.transparent,
          floatingActionButton: FloatingActionButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: const BorderSide(color: Colors.white)),
            backgroundColor: const Color.fromRGBO(15, 21, 39, 1),
            onPressed: () {
              showModalBottomSheet(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16.0),
                    topRight: Radius.circular(16.0),
                  ),
                ),
                constraints: BoxConstraints(
                  minWidth: MediaQuery.of(context).size.width,
                ),
                enableDrag: true,
                useSafeArea: true,
                isDismissible: true,
                showDragHandle: true,
                context: context,
                isScrollControlled: true,
                builder: (BuildContext context) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Text(
                          "Filters",
                          style: GoogleFonts.quicksand(fontSize: 30),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        FilterChipDemo(
                          isStarred: _isStarred,
                          isEvent: _isEvent,
                          isWorkshop: _isWorkshop,
                          isTechnical: _isTechnical,
                          isNonTechnical: _isNonTechnical,
                          isGroup: _isGroup,
                          isIndividual: _isIndividual,
                          onUpdateFilterStates: _updateFilterStates,
                          selectedTags: selectedTags,
                          tagData: tagData,
                        ),
                        const SizedBox(
                          height: 48,
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            child: const Icon(
              Icons.filter_list,
              color: Colors.white,
            ),
          ),
          appBar: AppBar(
            automaticallyImplyLeading: false,
            elevation: 0,
            backgroundColor: const Color.fromRGBO(43, 30, 56, 1),
            title: !_isSearching
                ? Text(
                    widget.isFeatured
                        ? 'Featured Events'
                        : 'Events & Workshops',
                    style: const TextStyle(color: Colors.white),
                  )
                : TextField(
                    controller: _searchQueryController,
                    autofocus: true,
                    decoration: const InputDecoration(
                      hintText: 'Search...',
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.white),
                    ),
                    style: const TextStyle(color: Colors.white, fontSize: 16.0),
                    onChanged:
                        _handleSearch, // Implement this method to filter your list
                  ),
            actions: [
              IconButton(
                icon: Icon(
                  _isSearching ? Icons.cancel : Icons.search,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    _isSearching = !_isSearching;
                    if (!_isSearching) {
                      _searchQueryController.clear();
                      if (widget.isFeatured == false) {
                        // _applyFilter();
                      } else {
                        // _applyFilterFeatures();
                      } // Reset the filter/search to show all items again
                    }
                  });
                },
              ),
            ],
          ),
          body: _isLoading
              ? const LoadingComponent()
              : Padding(
                  padding: const EdgeInsets.all(10),
                  child: _filteredEvents.isEmpty
                      ? Center(
                          child: Text(
                            widget.isFeatured
                                ? "No featured events found"
                                : "No events found",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                            ),
                          ),
                        )
                      : GridView.builder(
                          shrinkWrap: true,
                          padding: const EdgeInsets.only(
                            bottom: 68,
                          ),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio:
                                MediaQuery.of(context).size.width /
                                    (MediaQuery.of(context).size.height / 1.5),
                          ),
                          itemCount: _filteredEvents.length,
                          itemBuilder: (ctx, i) => EventCard(
                            event: _filteredEvents[i],
                            onTap: () {
                              Navigator.of(context).push(
                                PageRouteBuilder(
                                  pageBuilder: (context, animation,
                                          secondaryAnimation) =>
                                      FadeTransition(
                                    opacity: animation,
                                    child: EventDetailPage(
                                      eventId: _filteredEvents[i]["eventId"],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                ),
        ),
      ),
    );
  }

  Future<void> _pullRefresh() async {
    _getAllEvents();
    _getAllTags();
    // showToast("Refresh successul");
  }

  void _logOut() {
    //clearing the cache
    SharedPreferences.getInstance().then((sp) {
      sp.setBool("LOGGEDINKEY", false);
      sp.setString("NAME", "");
      // sp.setString("EMAIL", "");
      sp.setString("PHONE", "");
      sp.setString("COLLEGE", "");
      sp.setString("CITY", "");
      sp.setString("TOKEN", "");
    });
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const PrimaryScreen()),
        (route) => false);
  }
}

class EventCard extends StatelessWidget {
  final Map<String, dynamic> event;
  final VoidCallback onTap;

  const EventCard({super.key, required this.event, required this.onTap});

  @override
  Widget build(BuildContext context) {
    double gridWidth;
    if (MediaQuery.of(context).size.height > 700) {
      gridWidth = MediaQuery.of(context).size.height / 4.6 - 25;
    } else {
      gridWidth = MediaQuery.of(context).size.height / 5 - 26.0297;
    }

    final double imageHeight = gridWidth; // 16:9 aspect ratio for images
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.all(5),
      // Reduced margin
      clipBehavior: Clip.antiAlias,
      // Add this line to clip the content to the card's shape
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // Consistent border radius
      ),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(4),
              height: imageHeight,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    event["eventImageURL"],
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: Align(
                alignment: Alignment.topRight,
                child: event["isStarred"] != null
                    ? event["isStarred"] == "1"
                        ? const Icon(
                            Icons.favorite_rounded,
                            color: Colors.redAccent,
                          )
                        : const Icon(
                            Icons.favorite_outline,
                            color: Colors.grey,
                          )
                    : null,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0), // Reduced padding
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    event["eventName"],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14, // Smaller font size
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  if (event["tags"].length > 0) ...[
                    Wrap(
                      spacing: 4, // Reduced spacing
                      children: [
                        for (int index = 0;
                            index < min(event["tags"].length, 3);
                            index++) ...[
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  5), // Smaller border radius
                              border: Border.all(
                                  color: const Color.fromARGB(255, 8, 44, 68)),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2), // Reduced padding
                            child: Text(
                              event["tags"][index]["tagAbbreviation"]
                                  .toString(),
                              style: const TextStyle(
                                color: Color.fromARGB(255, 8, 44, 68),
                                fontWeight: FontWeight.bold,
                                fontSize: 10, // Smaller font size
                              ),
                            ),
                          )
                        ],
                      ],
                    ),
                  ],
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
// Date
                      Row(
                        children: <Widget>[
                          const Icon(Icons.calendar_today,
                              size: 12), // Smaller icon
                          const SizedBox(width: 4),
                          Text(
                            DateFormat("d'th' MMMM'").format(
                                DateFormat("yyyy-MM-DD")
                                    .parse(event["eventDate"])),
                            style: const TextStyle(
                              fontSize: 12, // Smaller font size
                            ),
                          ),
                        ],
                      ),
// Price
                      Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 8, 44, 68),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5, right: 5),
                          child: Row(
                            children: [
                              const Icon(Icons.currency_rupee,
                                  color: Colors.white,
                                  size: 12), // Smaller icon
                              const SizedBox(width: 4),
                              Text(
                                '${(event["eventPrice"] * 1.18).ceil()} /-',
                                style: GoogleFonts.quicksand(
                                  textStyle: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Colors.white // Smaller font size
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FilterChipDemo extends StatefulWidget {
  bool isWorkshop;
  bool isEvent;
  bool isTechnical;
  bool isNonTechnical;
  bool isGroup;
  bool isIndividual;
  bool isStarred;
  Function(bool, bool, bool, bool, bool, bool, bool) onUpdateFilterStates;
  List<Map<String, dynamic>> tagData;
  List<Map<String, dynamic>> selectedTags;

  FilterChipDemo(
      {super.key,
      required this.isStarred,
      required this.isWorkshop,
      required this.isEvent,
      required this.isTechnical,
      required this.isNonTechnical,
      required this.isGroup,
      required this.isIndividual,
      required this.onUpdateFilterStates,
      required this.selectedTags,
      required this.tagData});

  @override
  FilterChipDemoState createState() => FilterChipDemoState();
}

class FilterChipDemoState extends State<FilterChipDemo> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      runSpacing: -4.0,
      alignment: WrapAlignment.center,
      children: [
        FilterChip(
          label: const Text(
            'Workshop',
          ),
          selected: widget.isWorkshop,
          onSelected: (bool value) {
            setState(() {
              if (!widget.isWorkshop) {
                widget.isWorkshop = value;
                widget.isEvent = !value;
              } else {
                widget.isWorkshop = value;
              }
            });
            widget.onUpdateFilterStates(
                widget.isEvent,
                widget.isWorkshop,
                widget.isTechnical,
                widget.isNonTechnical,
                widget.isGroup,
                widget.isIndividual,
                widget.isStarred);
          },
        ),
        FilterChip(
          label: const Text('Event'),
          selected: widget.isEvent,
          onSelected: (bool value) {
            setState(() {
              if (!widget.isEvent) {
                widget.isEvent = value;
                widget.isWorkshop = !value;
              } else {
                widget.isEvent = value;
              }
            });
            widget.onUpdateFilterStates(
                widget.isEvent,
                widget.isWorkshop,
                widget.isTechnical,
                widget.isNonTechnical,
                widget.isGroup,
                widget.isIndividual,
                widget.isStarred);
          },
        ),
        FilterChip(
          label: const Text('Technical'),
          selected: widget.isTechnical,
          onSelected: (bool value) {
            setState(() {
              if (!widget.isTechnical) {
                widget.isTechnical = value;
                widget.isNonTechnical = !value;
              } else {
                widget.isTechnical = value;
              }
            });
            widget.onUpdateFilterStates(
                widget.isEvent,
                widget.isWorkshop,
                widget.isTechnical,
                widget.isNonTechnical,
                widget.isGroup,
                widget.isIndividual,
                widget.isStarred);
          },
        ),
        FilterChip(
          label: const Text('Non Technical'),
          selected: widget.isNonTechnical,
          onSelected: (bool value) {
            setState(() {
              if (!widget.isNonTechnical) {
                widget.isNonTechnical = value;
                widget.isTechnical = !value;
              } else {
                widget.isNonTechnical = value;
              }
            });
            widget.onUpdateFilterStates(
                widget.isEvent,
                widget.isWorkshop,
                widget.isTechnical,
                widget.isNonTechnical,
                widget.isGroup,
                widget.isIndividual,
                widget.isStarred);
          },
        ),
        FilterChip(
          label: const Text('Group'),
          selected: widget.isGroup,
          onSelected: (bool value) {
            setState(() {
              if (!widget.isGroup) {
                widget.isGroup = value;
                widget.isIndividual = !value;
              } else {
                widget.isGroup = value;
              }
            });
            widget.onUpdateFilterStates(
                widget.isEvent,
                widget.isWorkshop,
                widget.isTechnical,
                widget.isNonTechnical,
                widget.isGroup,
                widget.isIndividual,
                widget.isStarred);
          },
        ),
        FilterChip(
          label: const Text('Individual'),
          selected: widget.isIndividual,
          onSelected: (bool value) {
            setState(() {
              if (!widget.isIndividual) {
                widget.isIndividual = value;
                widget.isGroup = !value;
              } else {
                widget.isIndividual = value;
              }
            });
            widget.onUpdateFilterStates(
                widget.isEvent,
                widget.isWorkshop,
                widget.isTechnical,
                widget.isNonTechnical,
                widget.isGroup,
                widget.isIndividual,
                widget.isStarred);
          },
        ),
        FilterChip(
          label: const Text('Favourites'),
          selected: widget.isStarred,
          onSelected: (bool value) {
            setState(() {
              widget.isStarred = !widget.isStarred;
            });
            widget.onUpdateFilterStates(
                widget.isEvent,
                widget.isWorkshop,
                widget.isTechnical,
                widget.isNonTechnical,
                widget.isGroup,
                widget.isIndividual,
                widget.isStarred);
          },
        ),
        const SizedBox(
          height: 48,
        ),
        const Divider(
          thickness: 1,
        ),
        const SizedBox(
          height: 48,
        ),
        Wrap(
          spacing: 10,
          alignment: WrapAlignment.center,
          children: [
            for (int j = 0; j < widget.tagData.length; j++) ...[
              FilterChip(
                label: Text(widget.tagData[j]["tagName"]),
                selected: widget.selectedTags.contains(widget.tagData[j]),
                onSelected: (bool value) {
                  if (value == true) {
                    setState(() {
                      widget.selectedTags.add(widget.tagData[j]);
                    });
                  } else if (value == false) {
                    setState(() {
                      widget.selectedTags.remove(widget.tagData[j]);
                    });
                  }
                  widget.onUpdateFilterStates(
                      widget.isEvent,
                      widget.isWorkshop,
                      widget.isTechnical,
                      widget.isNonTechnical,
                      widget.isGroup,
                      widget.isIndividual,
                      widget.isStarred);
                },
              ),
            ],
          ],
        ),
      ],
    );
  }
}
