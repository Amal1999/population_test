class Stamp {
  late String country;
  late String city;
  late String population;
  late String year;
  late String? flag;
  late bool fav;

  Stamp(
      {required this.country,
      required this.city,
      required this.population,
      required this.year,
      this.flag,
      this.fav = false});

  Stamp.fromJson(Map<String, dynamic> json) {
    country = json['country'];
    city = json['city'];
    population = json['population'];
    year = json['year'];
    flag = json['flag'];
    fav = (json["fav"] == null) ? false : json["fav"];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['country'] = country ;
    _data['city'] = city ;
    _data['population'] = population ;
    _data['year'] = year ;
    _data['flag'] = flag ;
    _data['fav'] = fav ;
    return _data;
  }
}
