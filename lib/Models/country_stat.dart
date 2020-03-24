

import 'package:flutter/foundation.dart';

class Country_stat {

  String country ,flag ;
  int cases ,todayCases,deaths,todayDeaths,recovered,active ;

  Country_stat.fromJson(Map<String,dynamic> data){
    cases = data['cases'];
    todayCases = data['todayCases'];
    deaths = data['deaths'];
    todayDeaths = data['todayDeaths'];
    recovered = data['recovered'];
    country = data['country'];
    flag = data['countryInfo']['flag'];
    active = data['active'];
  }

}