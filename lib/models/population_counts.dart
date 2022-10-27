class PopulationCounts {
  PopulationCounts({
    required this.year,
    this.value,
    this.sex,
    this.reliabilty,
  });
  late final String year;
  late final String? value;
  late final String? sex;
  late final String? reliabilty;

  PopulationCounts.fromJson(Map<String, dynamic> json){
    year = json['year'];
    value = json['value'];
    sex = json['sex'];
    reliabilty = json['reliabilty'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['year'] = year;
    _data['value'] = value;
    _data['sex'] = sex;
    _data['reliabilty'] = reliabilty;
    return _data;
  }
}