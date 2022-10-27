import 'dart:convert';

import 'package:population_app/models/stamp.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesServices {
  static final FavoritesServices _service = FavoritesServices();

  static FavoritesServices get getService => _service;

  static List<Stamp> favs = [];

  getFav() async {
    if (favs.isEmpty) {
      SharedPreferences sp = await SharedPreferences.getInstance();

      if (sp.getStringList("favorites") != null) {
        List<String> list = sp.getStringList("favorites")!;
        for (var element in list) {
          Stamp s = Stamp.fromJson(jsonDecode(element))..fav = true;

          favs.add(s);
        }
      }
    }
  }

  addFav(Stamp stamp) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    if (sp.getStringList("favorites") == null) {
      sp.setStringList("favorites", []);
    }
    List<String> list = sp.getStringList("favorites")!;
    list.add(jsonEncode(stamp..fav = true));
    sp.setStringList("favorites", list);

    favs.add(stamp..fav = true);
  }

  deleteFav(Stamp stamp) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    List<String> list = sp.getStringList("favorites")!;
    list.remove(jsonEncode(stamp..fav = true));
    sp.setStringList("favorites", list);
    favs.removeWhere((element) =>
        (element..fav = true).toJson().toString() ==
        (stamp..fav = true).toJson().toString());
  }
}
