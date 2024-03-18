import 'package:async/async.dart';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:test_application/widgets/app/app_information_widget.dart';

import 'package:test_application/widgets/app/app_item_popup_dialog.dart';
import 'package:test_application/widgets/app/app_item.dart';
import 'package:test_application/widgets/app/app_list_item_widget.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class AppSearchContent extends StatefulWidget {

  const AppSearchContent({super.key});

  @override
  _AppSearchContent createState() => _AppSearchContent();
}

class _AppSearchContent extends State<AppSearchContent> with SingleTickerProviderStateMixin {

  late TextEditingController _searchController;
  AppItem? _selectedAppItem;
  AppItem? _previouslySelectedAppItem;

  final List<String> _sortByList = <String>['Downloads', 'Rating', 'Alphabetical'];
  late List<DropdownMenuItem<String>> _sortByItems = [];
  late String _sortByValue = _sortByList.first;

  final List<int> _numOfResultsList = <int>[10, 25, 50];
  late List<DropdownMenuItem<int>> _numOfResultsItems = [];
  late int _numOfResultsValue = _numOfResultsList.first;
  late int _currentPage = 0;

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  late List<AppItem> _entries = [];
  late List<AppItem> _filteredEntries = [];

  final AsyncMemoizer _memoizer = AsyncMemoizer();

  final double _maxWidthForPopup = 1000;

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
    return Padding(
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
    );
  }

  Widget _contentsForApps({bool forceReload = false})
  {
    final double mediaWidth = MediaQuery.of(context).size.width;
    
    // If on mobile/thin screen, use pop up for
    if (mediaWidth <= _maxWidthForPopup)
    {
      return _listForApps(forceReload: forceReload);
    }

    // Otherwise, split the screen to show the information on the right.
    return Expanded(
      child: Row(
        children: [
          _listForApps(forceReload: forceReload),
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            width: _selectedAppItem != null ? mediaWidth * 0.5 : 0,
            curve: Curves.easeIn,
            child: Row(
                children: [
                  const VerticalDivider(
                    width: 10
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Spacer(),
                              IconButton(
                                onPressed: () => _onAppPressed(null),
                                icon: const Icon(Icons.close))
                            ],
                          ),
                          AppInformationWidget(
                            appItem: _selectedAppItem != null ? _selectedAppItem! 
                            : _previouslySelectedAppItem != null ? _previouslySelectedAppItem! 
                            : AppItem.EmptyApp,
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
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

  Widget _listForApps({bool forceReload = false})
  {
    return FutureBuilder<String>(
      future: _updateAppData(forceReload: forceReload),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (!snapshot.hasData)
        {
          return const CircularProgressIndicator();
        }
        else if (snapshot.hasData && snapshot.data!.contains('Error'))
        {
          return Text(snapshot.data!);
        }
        else if (snapshot.hasData && snapshot.data!.contains('success'))
        {
          if (_filteredEntries.isEmpty)
          {
            return Text("No results found for: ${_searchController.text}");
          }

          int numOfResultsToRender = min(_numOfResultsValue, _filteredEntries.length - (_numOfResultsValue * _currentPage));
          
          return Expanded(
            child: Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(10.0),
                    itemCount: numOfResultsToRender,
                    itemBuilder: (BuildContext context, int index) {
                      int adjustedIndex = (_currentPage * _numOfResultsValue) + index;
                      return AppItemWidget(appItem: _filteredEntries[adjustedIndex], onPressed: _onAppPressed);
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 5.0),
                        child: Divider()
                      );
                    },
                  ),
                ),
                NumberPaginator(
                  initialPage: _currentPage,
                  numberPages: (_filteredEntries.length / _numOfResultsValue).ceil(),
                  onPageChange: (int index) => setState(() {
                    _currentPage = index;
                  }),
                ),
              ],
            ),
          );
        }
        else
        {
          return const CircularProgressIndicator();
        }
      });
    
  }

  Future<String> _updateAppData({bool forceReload = false}) async
  {
    String outcome = 'success';
    const String databaseCollection = 'apps';
   
   // Function to convert data to AppItem.
    void pullDataFromDocument (QuerySnapshot<Map<String, dynamic>> event) {
      for (var doc in event.docs) {
        var data = doc.data();
        setState(() {
          _entries.add(AppItem(
            title: data["title"],
            developer: data["developer"],
            publisher: data["publisher"],
            numOfDownloads: data["downloads"] ?? 0,
            rating: data["rating"],
            androidAppStoreURL: data["androidURL"],
            appleAppStoreURL: data["appleURL"],
            windowsAppStoreURL: data["windowsURL"]
          ));
        });
      }
    }

    // Load data into entries.
    if (forceReload)
    {
      _entries.clear();
      try {
        await _db.collection(databaseCollection).get().then(pullDataFromDocument);
      } on FirebaseException catch (e) {
        outcome = 'Error: Failed to load database with error code: ${e.code} and message: ${e.message}';
      }
    } else {
      _memoizer.runOnce(() async {
        _entries.clear();
        try {
          await _db.collection(databaseCollection).get().then(pullDataFromDocument);
        } on FirebaseException catch (e) {
          outcome = 'Error: Failed to load database with error code: ${e.code} and message: ${e.message}';
        }
      });
    }

    _filterEntries();
    _sortApps();

    if (_entries.isEmpty)
    {
      return "waiting";
    }

    return outcome;
  }

  void _sortApps()
  {
    setState(() {
      if (_sortByValue == 'Downloads')
      {
        _filteredEntries.sort((AppItem a, AppItem b) => -a.numOfDownloads.compareTo(b.numOfDownloads));
      }

      if (_sortByValue == 'Rating')
      {
        _filteredEntries.sort((AppItem a, AppItem b) => -a.rating.compareTo(b.rating));
      }

      if (_sortByValue == 'Alphabetical')
      {
        _filteredEntries.sort((AppItem a, AppItem b) => a.title.compareTo(b.title));
      }
    });
  }

  void _filterEntries()
  {
    setState(() {

      _filteredEntries.clear();

      _filteredEntries = _entries.where((AppItem app) {
        String searchString = _searchController.text.toLowerCase();
        if (searchString.isEmpty) { return true; }
        _currentPage = 0;
        return app.title.toLowerCase().contains(searchString)
        || app.developer.toLowerCase().contains(searchString) 
        || (app.publisher != null ? app.publisher!.toLowerCase().contains(searchString) : false);
      }).toList();
    }); 
  }

  void _onAppPressed(AppItem? app)
  {
    if (app == _selectedAppItem) { app = null; }

    setState(() {
      _previouslySelectedAppItem = _selectedAppItem;
      _selectedAppItem = app;
      });

    if (app == null)
    {
      return;
    }

    if (MediaQuery.of(context).size.width < _maxWidthForPopup)
    {
      AppItemPopupDialog.showAppPopupDialog(context, app);
      return;
    }
  }

  void _onSearchBarChanged(String value)
  {
    // Update results shown on change.
    _filterEntries();
  }

  void _onSearchBarSubmit(String value)
  {
    // Update results shown on change.
    _filterEntries();
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