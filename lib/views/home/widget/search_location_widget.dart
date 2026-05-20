import 'package:flutter/material.dart';
import 'package:optigo/providers/search_provider.dart';
import 'package:optigo/models/place_model.dart';

/// Widget tìm kiếm địa điểm với dropdown gợi ý riêng biệt.
/// Mỗi instance có [SearchProvider] độc lập để tránh xung đột giữa
/// ô nhập điểm đi và điểm đến.
class SearchLocationWidget extends StatefulWidget {
  final String hintText;
  final Function(PlaceModel)? onSelected;
  final TextEditingController? controller;
  final String? initialText;

  const SearchLocationWidget({
    super.key,
    required this.hintText,
    this.onSelected,
    this.controller,
    this.initialText,
  });

  @override
  State<SearchLocationWidget> createState() => _SearchLocationWidgetState();
}

class _SearchLocationWidgetState extends State<SearchLocationWidget> {
  // Mỗi widget có SearchProvider riêng để tránh xung đột
  late final SearchProvider _searchProvider;
  TextEditingController? _internalController;
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();

  TextEditingController get _controller =>
      widget.controller ?? _internalController!;

  @override
  void initState() {
    super.initState();
    _searchProvider = SearchProvider();
    if (widget.controller == null) {
      _internalController = TextEditingController(
        text: widget.initialText ?? '',
      );
    } else if (widget.initialText != null) {
      widget.controller!.text = widget.initialText!;
    }
    _controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    final text = _controller.text;
    if (text.isEmpty) {
      _removeOverlay();
      _searchProvider.clearResults();
    } else {
      _searchProvider.searchPlace(text).then((_) {
        if (mounted && _searchProvider.searchResults.isNotEmpty) {
          _showOverlay();
        } else {
          _removeOverlay();
        }
      });
    }
  }

  void _showOverlay() {
    _removeOverlay();
    _overlayEntry = _buildOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _buildOverlayEntry() {
    return OverlayEntry(
      builder: (context) {
        return Positioned(
          width: MediaQuery.of(context).size.width - 32,
          child: CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            offset: const Offset(0, 48),
            child: Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(8),
              child: AnimatedBuilder(
                animation: _searchProvider,
                builder: (context, _) {
                  if (_searchProvider.isSearching) {
                    return const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  final results = _searchProvider.searchResults;
                  if (results.isEmpty) {
                    return const ListTile(
                      title: Text('Không tìm thấy kết quả'),
                    );
                  }
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: results.map((place) {
                      return ListTile(
                        title: Text(place.mainText),
                        subtitle: Text(
                          place.secondaryText,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        onTap: () {
                          _controller.text = place.description;
                          _removeOverlay();
                          _searchProvider.clearResults();
                          widget.onSelected?.call(place);
                        },
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _removeOverlay();
    _controller.removeListener(_onTextChanged);
    _internalController?.dispose();
    _searchProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(
          hintText: widget.hintText,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
        ),
        onTap: () {
          if (_controller.text.isNotEmpty &&
              _searchProvider.searchResults.isNotEmpty) {
            _showOverlay();
          }
        },
      ),
    );
  }
}
