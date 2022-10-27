import 'package:population_app/models/population_counts.dart';

class Population {
  Population({
    required this.city,
    required this.country,
    required this.populationCounts,
  });
  late final String city;
  late final String country;
  late final List<PopulationCounts> populationCounts;

  Population.fromJson(Map<String, dynamic> json){
    city = json['city'];
    country = json['country'];
    populationCounts = List.from(json['populationCounts']).map((e)=>PopulationCounts.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['city'] = city;
    _data['country'] = country;
    _data['populationCounts'] = populationCounts.map((e)=>e.toJson()).toList();
    return _data;
  }
}

