import 'package:flutter/material.dart';

class AppSearchContent extends StatefulWidget {

  const AppSearchContent({super.key});

  @override
  _AppSearchContent createState() => _AppSearchContent();
}

class _AppSearchContent extends State<AppSearchContent> {

  late TextEditingController _searchController;

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
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SearchBar(
              constraints: BoxConstraints.expand(width: MediaQuery.of(context).size.width, height: 50),
              leading: const Icon(Icons.search),
              hintText: 'Search for App by Title, Developer, or Publisher',
              hintStyle: MaterialStateProperty.all(const TextStyle(color: Colors.black45)),
              controller: _searchController,
              onChanged: _onSearchBarChanged,
              onSubmitted: _onSearchBarSubmit,
            ),
            Padding(
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
            )
          ]
        ),
      ),
    );
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