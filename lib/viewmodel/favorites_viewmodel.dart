import 'package:flutter/material.dart';
import 'package:population_app/models/stamp.dart';
import 'package:population_app/services/favorites_services.dart';

class FavoritesViewModel extends ChangeNotifier {
  NotifierState _state = NotifierState.Loading;

  bool get isLoading => _state == NotifierState.Loading;

  bool get hasData => _state == NotifierState.HasData;

  bool get empty => _state == NotifierState.NotFound;

  List<Stamp> favorites = [];

  FavoritesViewModel() {
    getFav();
  }

  getFav() async {
    _state = NotifierState.Loading;
    notifyListeners();
    await FavoritesServices.getService.getFav();
    favorites = FavoritesServices.favs;
    if (favorites.isEmpty) {
      _state = NotifierState.NotFound;
    } else {
      _state = NotifierState.HasData;
    }
    notifyListeners();
  }

  addFav(Stamp stamp) async {
    _state = NotifierState.Loading;
    notifyListeners();

    await FavoritesServices.getService.addFav(stamp);

    favorites = FavoritesServices.favs;

    if (favorites.isEmpty) {
      _state = NotifierState.NotFound;
    } else {
      _state = NotifierState.HasData;
    }
    notifyListeners();
  }

  deleteFav(Stamp stamp) async {
    _state = NotifierState.Loading;
    notifyListeners();

    await FavoritesServices.getService.deleteFav(stamp);

    favorites = FavoritesServices.favs;

    if (favorites.isEmpty) {
      _state = NotifierState.NotFound;
    } else {
      _state = NotifierState.HasData;
    }

    notifyListeners();
  }
}

enum NotifierState { Loading, HasData, NotFound }
