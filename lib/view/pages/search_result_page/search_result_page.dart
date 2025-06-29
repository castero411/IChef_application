import 'package:flutter/material.dart';
import 'package:i_chef_application/view/commonWidgets/item_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:i_chef_application/view/text_styles.dart';

class SearchResultsPage extends StatefulWidget {
  final String query;

  const SearchResultsPage({super.key, required this.query});

  @override
  State<SearchResultsPage> createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  final TextEditingController _controller = TextEditingController();
  String currentQuery = '';

  @override
  void initState() {
    super.initState();
    currentQuery = widget.query;
    _controller.text = widget.query;
    _saveToHistory(widget.query); // optional
  }

  Future<void> _handleSearch(String text) async {
    if (text.trim().isEmpty) return;

    setState(() {
      currentQuery = text.trim();
    });

    _controller.text = text;
    await _saveToHistory(text);

    // TODO: Add logic here to actually refresh search results
    print("Searching for: $text");
  }

  Future<void> _saveToHistory(String query) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList('searchHistory') ?? [];

    history.remove(query);
    history.insert(0, query);
    if (history.length > 10) {
      history = history.sublist(0, 10);
    }

    await prefs.setStringList('searchHistory', history);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(currentQuery, style: secondarytitle25)),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsetsGeometry.symmetric(horizontal: 15),
            child: TextField(
              controller: _controller,
              onSubmitted: _handleSearch,
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
          ),
          const SizedBox(height: 20),
          ItemWidget(),
          ItemWidget(),

          ItemWidget(),

          ItemWidget(),

          // TODO: Add your search result list here
        ],
      ),
    );
  }
}
