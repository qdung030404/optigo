import 'dart:async';
import 'package:flutter/material.dart';
import 'package:optigo/providers/search_provider.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  final String hintText;
  const SearchPage({super.key, this.hintText = 'Tìm kiếm địa điểm...'});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        context.read<SearchProvider>().searchPlace(query);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: widget.hintText,
            border: InputBorder.none,
            hintStyle: const TextStyle(color: Colors.grey),
          ),
          onChanged: _onSearchChanged,
        ),
        actions: [
          if (_searchController.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear, color: Colors.grey),
              onPressed: () {
                _searchController.clear();
                context.read<SearchProvider>().clearResults();
                setState(() {});
              },
            ),
        ],
      ),
      body: Consumer<SearchProvider>(
        builder: (context, searchProvider, child) {
          if (searchProvider.isSearching) {
            return const Center(child: CircularProgressIndicator());
          }

          final results = _searchController.text.isEmpty
              ? searchProvider.searchHistory
              : searchProvider.searchResults;

          if (results.isEmpty) {
            return Center(
              child: Text(
                _searchController.text.isEmpty
                    ? 'Bắt đầu tìm kiếm điểm đến của bạn'
                    : 'Không tìm thấy kết quả phù hợp',
                style: const TextStyle(color: Colors.grey),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: results.length + (_searchController.text.isEmpty ? 1 : 0),
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              if (_searchController.text.isEmpty && index == 0) {
                return const Padding(
                  padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: Text(
                    'Tìm kiếm gần đây',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                );
              }

              final place = _searchController.text.isEmpty 
                  ? results[index - 1] 
                  : results[index];

              return ListTile(
                leading: Icon(
                  _searchController.text.isEmpty 
                    ? Icons.history 
                    : Icons.location_on_outlined,
                  color: Colors.grey,
                ),
                title: Text(place.mainText, maxLines: 1, overflow: TextOverflow.ellipsis),
                subtitle: Text(
                  place.secondaryText,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12),
                ),
                onTap: () {
                  searchProvider.addToHistory(place);
                  Navigator.pop(context, place);
                },
              );
            },
          );
        },
      ),
    );
  }
}
