import 'dart:convert';

import 'package:corona_tracker/Model/WorldStatesModel.dart';
import 'package:corona_tracker/Services/Utilities/app_url.dart';
import 'package:http/http.dart' as http;


class StatesServices {

  Future<WorldStatsModel> fetchWorldStatesRecords() async {

    final response = await http.get(Uri.parse(AppUrl.worldStatsApi));

    if (response.statusCode == 200) {

      var data = jsonDecode(response.body);
      return WorldStatsModel.fromJson(data);

    } else {
      throw Exception("Error");
    }
  }


  Future<List<dynamic>> countryListApi() async {

    final response = await http.get(Uri.parse(AppUrl.countriesList));

    if (response.statusCode == 200) {

     var data = jsonDecode(response.body);
      return data;

    } else {
      throw Exception("Error");
    }
  }
}
