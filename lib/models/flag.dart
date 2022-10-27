class Flag {
  Flag({
    required this.name,
    required this.flag,
    required this.iso2,
    required this.iso3,
  });
  late final String name;
  late final String flag;
  late final String? iso2;
  late final String? iso3;

  Flag.fromJson(Map<String, dynamic> json){
    name = json['name'];
    flag = json['flag'];
    iso2 = json['iso2'];
    iso3 = json['iso3'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['name'] = name;
    _data['flag'] = flag;
    _data['iso2'] = iso2;
    _data['iso3'] = iso3;
    return _data;
  }
}