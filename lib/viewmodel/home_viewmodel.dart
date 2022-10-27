import 'package:flutter/material.dart';
import 'package:population_app/models/dto/flag_dto.dart';
import 'package:population_app/models/flag.dart';
import 'package:population_app/services/favorites_services.dart';
import 'package:population_app/services/stamp_services.dart';

import '../models/stamp.dart';

class HomeViewModel extends ChangeNotifier {
  NotifierState _state = NotifierState.Loading;

  bool get isLoading => _state == NotifierState.Loading;

  bool get hasData => _state == NotifierState.HasData;

  bool get empty => _state == NotifierState.NotFound;

  List<Stamp> stamps = [];
  List<Stamp> filtered = [];
  List<Stamp> favorites = [];
  List<Flag> flags = [];

  HomeViewModel() {
    getStamps();
  }

  getStamps() async {
    stamps.clear();
    flags.clear();
    _state = NotifierState.Loading;
    notifyListeners();
    await StampServices.getService().getStamps();
    stamps = StampServices.stamps;
    flags = StampServices.flags;

    await _checkFavs();

    if (stamps.isEmpty) {
      _state = NotifierState.NotFound;
    } else {
      _state = NotifierState.HasData;
    }
    notifyListeners();
  }

  /// Filter stamps by country name
  filter(String name) async {
    _state = NotifierState.Loading;
    notifyListeners();
    stamps = stamps.where((element) => element.country == name).toList();
    if (stamps.isEmpty) {
      _state = NotifierState.NotFound;
    } else {
      _state = NotifierState.HasData;
    }
    notifyListeners();
  }

  /// Check if there is favorite stamps
  /// if so, mark as favorite
  _checkFavs() async {
    if (FavoritesServices.favs.isEmpty) {
      await FavoritesServices.getService.getFav();
    }
    favorites = FavoritesServices.favs;
    for (var element in stamps) {
      for (var favorite in favorites) {
        element.fav = true;
        if (element.toJson().toString() == favorite.toJson().toString()) {
          break;
        }
        element.fav = false;
      }
    }
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
    await FavoritesServices.getService.deleteFav(stamp);

    print(favorites.length);
    favorites = FavoritesServices.favs;
    print(favorites.length);

    await _checkFavs();
  }
}

enum NotifierState { Loading, HasData, NotFound }
