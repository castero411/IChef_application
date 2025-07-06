import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:i_chef_application/view/text_styles.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  List<String> searchHistory = [];

  @override
  void initState() {
    super.initState();
    _loadSearchHistory();
  }

  Future<void> _loadSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      searchHistory = prefs.getStringList('searchHistory') ?? [];
    });
  }

  Future<void> _saveSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('searchHistory', searchHistory);
  }

  void _handleSearch(String query) {
    if (query.trim().isEmpty) return;

    // Update history
    setState(() {
      searchHistory.remove(query); // move to top if exists
      searchHistory.insert(0, query);
      if (searchHistory.length > 10) {
        searchHistory = searchHistory.sublist(0, 10);
      }
    });
    _saveSearchHistory();

    _controller.clear();

    // Navigate to search results page
    Navigator.pushNamed(context, 'search result', arguments: query);

    setState(() {
      _loadSearchHistory();
    });
  }

  void _removeFromHistory(String item) async {
    setState(() {
      searchHistory.remove(item);
    });
    _saveSearchHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Search', style: secondarytitle25)),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
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
            Gap(15),

            Text("History", style: black20),
            Gap(10),
            Expanded(
              child:
                  searchHistory.isEmpty
                      ? Center(child: Text("No search history yet."))
                      : ListView.builder(
                        itemCount: searchHistory.length,
                        itemBuilder: (context, index) {
                          final item = searchHistory[index];
                          return HistoryItem(
                            text: item,
                            onDelete: () => _removeFromHistory(item),
                            onTap: () => _handleSearch(item),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}

class HistoryItem extends StatelessWidget {
  final String text;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  const HistoryItem({
    super.key,
    required this.text,
    required this.onDelete,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(text),
      leading: Icon(Icons.history),
      trailing: IconButton(
        icon: Icon(Icons.close_rounded),
        onPressed: onDelete,
      ),
      onTap: onTap,
    );
  }
}
