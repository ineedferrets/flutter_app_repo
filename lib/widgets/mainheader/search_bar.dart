import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {

  const SearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: const TextField(
        decoration: InputDecoration(
          labelText: 'Search for Games by Title, Developer, or Publisher',
          border: OutlineInputBorder(),
          filled: false,
          prefixIcon: Icon(Icons.search),
        ),
      )
    );
  }
}