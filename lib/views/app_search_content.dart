import 'package:flutter/material.dart';
import 'package:test_application/widgets/app_item_widget.dart';

import 'package:firebase_database/firebase_database.dart';

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
  late String dropdownValue = _sortByList.first;

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
            SearchBar( // Search Bar for searching for app.
              constraints: BoxConstraints.expand(width: MediaQuery.of(context).size.width, height: 50),
              leading: const Icon(Icons.search),
              hintText: 'Search for App by Title, Developer, or Publisher',
              hintStyle: MaterialStateProperty.all(const TextStyle(color: Colors.black45)),
              controller: _searchController,
              onChanged: _onSearchBarChanged,
              onSubmitted: _onSearchBarSubmit,
            ),
            Padding( // Dropdowns for filtering apps.
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text("Sort by:"),
                  const SizedBox(width: 10, height: 10),
                  DropdownButton<String>(
                    value: dropdownValue,
                    items: _sortByItems,
                    onChanged: _onSortByChanged
                  ),
                ],
              ),
            ),
            _listForApps()
          ]
        ),
      ),
    );
  }

  Widget _contentsForApps()
  {
    if (_selectedAppItem == null)
    {
      return _listForApps();
    }
    else
    {
      return _listForApps();
    }
  }

  // Test entries
  final List<AppItem> entries = [
    AppItem(title: "Game Title", developer: "Developer", publisher: "Publisher", rating: 4.2, appIcon: Icons.shield_moon, androidAppStoreURL: "https://www.google.co.uk"),
    AppItem(title: "Game Title", developer: "Developer", publisher: "Publisher", rating: 4.9, appIcon: Icons.book),
    AppItem(title: "Game Title", developer: "Developer", publisher: "Publisher", rating: 1.2, appIcon: Icons.refresh),
    AppItem(title: "Game Title", developer: "Developer", publisher: "Publisher", rating: 0.4, appIcon: Icons.gamepad),
    AppItem(title: "Game Title", developer: "Developer", publisher: "Publisher", rating: 2.6, appIcon: Icons.email),    
  ];

  Widget _listForApps()
  {
    return Expanded(
      child: ListView.separated(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
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
    // Update results shown on change.
    setState(() {dropdownValue = value!;});
  }
}