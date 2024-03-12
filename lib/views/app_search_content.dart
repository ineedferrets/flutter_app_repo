import 'dart:async';
import 'package:async/async.dart';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:test_application/widgets/app_item_widget.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class AppSearchContent extends StatefulWidget {

  const AppSearchContent({super.key});

  @override
  _AppSearchContent createState() => _AppSearchContent();
}

class _AppSearchContent extends State<AppSearchContent> {

  late TextEditingController _searchController;
  AppItem? _selectedAppItem;

  final List<String> _sortByList = <String>['Downloads', 'Rating', 'Alphabetical'];
  late List<DropdownMenuItem<String>> _sortByItems = [];
  late String _sortByValue = _sortByList.first;

  final List<int> _numOfResultsList = <int>[10, 25, 50];
  late List<DropdownMenuItem<int>> _numOfResultsItems = [];
  late int _numOfResultsValue = _numOfResultsList.first;

  final FirebaseFirestore db = FirebaseFirestore.instance;
  late List<AppItem> entries = [];

  final AsyncMemoizer _memoizer = AsyncMemoizer();

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();

    _sortByItems = _sortByList.map<DropdownMenuItem<String>>(
    (String value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(value)
      );
    }).toList();

    _numOfResultsItems = _numOfResultsList.map<DropdownMenuItem<int>>(
      (int value) {
        return DropdownMenuItem<int>(
          value: value,
          child: Text(value.toString())
        );
      }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _searchBarWidget(),
            _filterWidgets(),
            _contentsForApps()
          ]
        ),
      ),
    );
  }

  Widget _contentsForApps()
  {
    if (_selectedAppItem == null)
    {
      return FutureBuilder<String>(
        future: _getAppData(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot){
          if (snapshot.data != null && snapshot.data!.contains('error'))
          {
            print("Failure ${snapshot.data}");
            return Text(snapshot.data ?? 'Error in site code.');
          }
          else
          {
            print("Success ${snapshot.data}");
            return _listForApps();  
          } 
        });
    }
    else
    {
      return FutureBuilder<String>(
        future: _getAppData(),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot){
          return _listForApps();
        });
    }
  }

  var rng = Random();

  Widget _searchBarWidget()
  {
    return SearchBar( // Search Bar for searching for app.
        constraints: BoxConstraints.expand(width: MediaQuery.of(context).size.width, height: 50),
        leading: const Icon(Icons.search),
        hintText: 'Search for App by Title, Developer, or Publisher',
        hintStyle: MaterialStateProperty.all(const TextStyle(color: Colors.black45)),
        controller: _searchController,
        onChanged: _onSearchBarChanged,
        onSubmitted: _onSearchBarSubmit,
    );
  }

  Widget _filterWidgets()
  {
    return
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Sort by dropdown --------------
              const Text("Sort by:"),
              const SizedBox(width: 10),
              DropdownButton<String>(
                value: _sortByValue,
                items: _sortByItems,
                onChanged: _onSortByChanged
              ),
              // -------------------------------
              const SizedBox(width: 40),
              // Num of results dropdown -------
              const Text("Items per page:"),
              const SizedBox(width: 10),
              DropdownButton<int>(
                value: _numOfResultsValue,
                items: _numOfResultsItems,
                onChanged: _onNumOfResultsChanged,
              ),
              // ------------------------------
            ],
          ),
        );
  }

  Widget _listForApps()
  {
    return Expanded(
      child: ListView.separated(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(10.0),
        itemCount: entries.length,
        itemBuilder: (BuildContext context, int index) {
          return AppItemWidget(appItem: entries[index], onPressed: _onAppPressed);
        },
        separatorBuilder: (BuildContext context, int index) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0),
            child: Divider()
          );
        },
      ),
    );
  }

  Future<String> _getAppData ({bool forceReload = false}) async
  {
    String outcome = '';
   
    void pullDataFromDocument (QuerySnapshot<Map<String, dynamic>> event) {
      for (var doc in event.docs) {
        var data = doc.data();
        entries.add(AppItem(
          title: data["title"],
          developer: data["developer"],
          publisher: data["publisher"],
          numOfDownloads: data["downloads"] ?? 0,
          rating: data["rating"],
          androidAppStoreURL: data["androidURL"],
          appleAppStoreURL: data["appleURL"],
          windowsAppStoreURL: data["windowsURL"]
        ));
      }
    };

    if (forceReload)
    {
      entries.clear();
      try {
        await db.collection("apps").get().then(pullDataFromDocument);
      } on FirebaseException catch (e) {
        outcome = 'Failed to load database with error code: ${e.code} and message: ${e.message}';
      }
    } else {
      _memoizer.runOnce(() async {
        entries.clear();
        try {
          await db.collection("apps").get().then(pullDataFromDocument);
        } on FirebaseException catch (e) {
          outcome = 'Failed to load database with error code: ${e.code} and message: ${e.message}';
        }
      });
    }
    return outcome;
  }

  Future<void> _sortApps() async
  {
    if (_sortByValue == 'Downloads')
    {
      setState(() {
        entries.sort((AppItem a, AppItem b) => -a.numOfDownloads.compareTo(b.numOfDownloads));
      });
    }

    if (_sortByValue == 'Rating')
    {
      setState(() {
        entries.sort((AppItem a, AppItem b) => -a.rating.compareTo(b.rating));
      });
    }

    if (_sortByValue == 'Alphabetical')
    {
      setState(() {
        entries.sort((AppItem a, AppItem b) => a.title.compareTo(b.title));
      });
    }
  }

  void _onAppPressed()
  {

  }

  void _onSearchBarChanged(String value)
  {
    // Update results shown on change.
  }

  void _onSearchBarSubmit(String value)
  {
    // Update results shown on change.
  }

  void _onSortByChanged(String? value)
  {
    if (value == null) { Exception("Sort by changed to null value."); }
    // Update results shown on change.
    setState(() {_sortByValue = value!;});

    _sortApps();
  }

  void _onNumOfResultsChanged(int? value)
  {
    if (value == null) { Exception("Number of results changed to null value."); }
    setState(() {_numOfResultsValue = value!;});
  }

  void _getSubsectionOfDatabase()
  {
    
  }
}