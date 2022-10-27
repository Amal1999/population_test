import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:population_app/models/dto/flag_dto.dart';
import 'package:population_app/models/dto/population_dto.dart';
import 'package:population_app/models/flag.dart';
import 'package:population_app/models/population.dart';
import 'package:population_app/models/stamp.dart';
import 'package:population_app/settings/const.dart';

class StampServices {
  static final StampServices _service = StampServices();

  static StampServices getService() => _service;

  static List<Flag> flags = [];
  static List<Stamp> stamps = [];

  Future<Map<String, dynamic>> getStamps() async {
    var client = http.Client();
    try {
      var response = await client.get(
        Uri.parse('${Const.url}/population/cities'),
      );

      List<Population> populations =
          PopulationDTO.fromJson(jsonDecode(response.body)).data;

      int flagIndex;
      for (var element in populations) {
        for (var e in element.populationCounts) {
          if (flags.isEmpty) {
            await getFlags();
          }
          flagIndex = flags.indexWhere((e1) => e1.name == element.country);
          if (e.value != null && flagIndex != -1) {
            stamps.add(Stamp(
                country: element.country,
                city: element.city,
                population: e.value!,
                year: e.year,
                flag: flagIndex != -1 ? flags[flagIndex].iso2 : null));
          }
        }
      }
    } catch (e) {
      return ({"message": "request is not send"});
    }
    client.close();
    return ({"message": "internal error"});
  }

  Future<List<Flag>> getFlags() async {
    var client = http.Client();
    try {
      var response = await client.get(
        Uri.parse('${Const.url}/flag/images'),
      );

      flags = FlagDTO.fromJson(jsonDecode(response.body)).data;

      return flags;
    } catch (e) {}
    client.close();
    return [];
  }
}
