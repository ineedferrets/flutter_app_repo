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

    // Test entries
  final List<AppItem> entries = [
    //AppItem(title: "Labyrinth of Oracle", developer: "Developer", publisher: "Publisher", rating: 4.2, appIcon: Icons.shield_moon, androidAppStoreURL: "https://www.google.co.uk", numOfDownloads: 2000000000),
    //AppItem(title: "Territories of Eternity", developer: "Developer", publisher: "Publisher", rating: 4.9, appIcon: Icons.book, androidAppStoreURL: "https://www.google.co.uk", numOfDownloads: 30000),
    //AppItem(title: "Moon Chalice", developer: "Developer", publisher: "Publisher", rating: 1.2, appIcon: Icons.refresh, androidAppStoreURL: "https://www.google.co.uk", numOfDownloads: 25),
    //AppItem(title: "Underworld of Oracle", developer: "Developer", publisher: "Publisher", rating: 0.4, appIcon: Icons.gamepad, androidAppStoreURL: "https://www.google.co.uk"),
    //AppItem(title: "Treasure City", developer: "Developer", publisher: "Publisher", rating: 2.6, appIcon: Icons.email),    
    //AppItem(title: "Wonders of the Solitude", developer: "Developer", publisher: "Publisher", rating: 1, appIcon: Icons.abc),    
    //AppItem(title: "The Radiant Chalice", developer: "Developer", publisher: "Publisher", rating: 4.3, appIcon: Icons.back_hand),    
    //AppItem(title: "Tundra of Legends", developer: "Developer", publisher: "Publisher", rating: 5, appIcon: Icons.cable),    
    //AppItem(title: "Heroes of the Relics", developer: "Developer", publisher: "Publisher", rating: 3, appIcon: Icons.dashboard),    
    //AppItem(title: "Avengers of the Resilience", developer: "Developer", publisher: "Publisher", rating: 3.4, appIcon: Icons.earbuds),    
    //AppItem(title: "Citadel of Shadow", developer: "Developer", publisher: "Publisher", rating: 1.2, appIcon: Icons.face),    
    //AppItem(title: "Citadel of Comets", developer: "Developer", publisher: "Publisher", rating: 0.2, appIcon: Icons.g_mobiledata),    
    //AppItem(title: "Avalanche Starship", developer: "Developer", publisher: "Publisher", rating: 4.2, appIcon: Icons.hail),    
    //AppItem(title: "Forest Hero", developer: "Developer", publisher: "Publisher", rating: 4.5, appIcon: Icons.icecream),    
    //AppItem(title: "Fire Airship", developer: "Developer", publisher: "Publisher", rating: 2.6, appIcon: Icons.join_right),    
    //AppItem(title: "Citadel of Wizards", developer: "Developer", publisher: "Publisher", rating: 3.2, appIcon: Icons.key),    
    //AppItem(title: "Phoenix Beacon", developer: "Developer", publisher: "Publisher", rating: 2.1, appIcon: Icons.lan),    
    //AppItem(title: "Comet Anvil", developer: "Developer", publisher: "Publisher", rating: 1.8, appIcon: Icons.mail),    
    //AppItem(title: "Champions of the Desolation", developer: "Developer", publisher: "Publisher", rating: 1.1, appIcon: Icons.nat),    
    //AppItem(title: "Monster Soccer", developer: "Developer", publisher: "Publisher", rating: 4, appIcon: Icons.opacity),    
    //AppItem(title: "The Brave City", developer: "Developer", publisher: "Publisher", rating: 5, appIcon: Icons.pages),    
    //AppItem(title: "Haunted Soccer", developer: "Developer", publisher: "Publisher", rating: 2, appIcon: Icons.qr_code),    
  ];

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
        initialData: "Loading app data...",
        builder: (BuildContext context, AsyncSnapshot<String> snapshot){
          if (snapshot.hasData && snapshot.data!.contains("Error"))
          {
            return const Text("Database is unavailable at the moment.");
          }
          else
          {
            return _listForApps();
          }
        });
    }
    else
    {
      return FutureBuilder<String>(
        future: _getAppData(),
        initialData: "Loading app data...",
        builder: (BuildContext context, AsyncSnapshot<String> snapshot){
          if (snapshot.hasData && snapshot.data!.contains("Error"))
          {
            return const Text("Database is unavailable at the moment.");
          }
          else
          {
            return _listForApps();
          }
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

  Future<String> _getAppData () async
  {
    entries.clear();
    await db.collection("apps").get().then((event) {
      for (var doc in event.docs) {
        var data = doc.data();
        entries.add(AppItem(
          title: data["title"],
          developer: data["developer"],
          publisher: data["publisher"],
          numOfDownloads: data["downloads"],
          rating: data["rating"],
          androidAppStoreURL: data["androidURL"],
          appleAppStoreURL: data["appleURL"],
          windowsAppStoreURL: data["windowsURL"]
        ));
      }
    });

    if (entries.isEmpty)
    {
      return "Error: Database could not be loaded.";
    }

    return "Success";
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
  }

  void _onNumOfResultsChanged(int? value)
  {
    if (value == null) { Exception("Number of results changed to null value."); }
    setState(() {_numOfResultsValue = value!;});
  }
}