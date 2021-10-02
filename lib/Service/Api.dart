import 'dart:convert';

import 'package:coronaapp/Models/country_stat.dart';
import 'package:http/http.dart' as http;

class Api {
  Future<dynamic> getData(String c_name) async {
    try {
      String base_url =
          'https://corona.lmao.ninja/v3/covid-19/countries/$c_name';
      var response = await http.get(base_url);
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);

        return Country_stat.fromJson(jsonResponse);
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } catch (e) {
      return null;
    }
  }
}
