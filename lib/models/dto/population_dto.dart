import 'package:population_app/models/population.dart';

class PopulationDTO {
  PopulationDTO({
    required this.error,
    required this.msg,
    required this.data,
  });
  late final bool error;
  late final String msg;
  late final List<Population> data;

  PopulationDTO.fromJson(Map<String, dynamic> json){
    error = json['error'];
    msg = json['msg'];
    data = List.from(json['data']).map((e)=>Population.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['error'] = error;
    _data['msg'] = msg;
    _data['data'] = data.map((e)=>e.toJson()).toList();
    return _data;
  }
}

