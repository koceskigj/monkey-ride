import 'package:flutter/material.dart';

class StopsProvider extends ChangeNotifier {
  String _searchQuery = '';
  String _selectedDirection = 'west_to_east';

  String get searchQuery => _searchQuery;
  String get selectedDirection => _selectedDirection;
  bool get isWestToEast => _selectedDirection == 'west_to_east';
  bool get isEastToWest => _selectedDirection == 'east_to_west';

  void updateSearchQuery(String value) {
    _searchQuery = value;
    notifyListeners();
  }

  void selectDirection(String direction) {
    if (_selectedDirection == direction) return;
    _selectedDirection = direction;
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    notifyListeners();
  }

  void reset() {
    _searchQuery = '';
    _selectedDirection = 'west_to_east';
    notifyListeners();
  }
}