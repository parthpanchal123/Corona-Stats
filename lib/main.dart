import 'package:coronaapp/Models/country_stat.dart';
import 'package:coronaapp/Service/Api.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ola_like_country_picker/ola_like_country_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

ProgressDialog pr;
AnimationController rotationController;

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          accentColor: Colors.purple[900],
          primaryColor: Colors.purple[900],
          fontFamily: 'ProductSans'),
      home: Provider(create: (_) => Api(), child: MyApp()),
    ));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  CountryPicker countryPicker;
  Country country =
      Country.fromJson({"Name": "India", "ISO": "in", "Code": "91"});
  _fetchdata(String c_name) async {
    Country_stat now = await Api().getData(c_name);
    print(now.country);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _fetchdata('India');
    countryPicker = CountryPicker(onCountrySelected: (Country country) {
      pr.show();
      Future.delayed(Duration(seconds: 3)).then((onValue) {
        if (pr.isShowing()) {
          pr.dismiss();
        }
      });
      final curr_name = country.name;
      _fetchdata(curr_name);
      setState(() {
        this.country = country;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final _api = Provider.of<Api>(context, listen: false);
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.style(
      message: 'Getting latest data',
      borderRadius: 10.0,
      progressWidget: Container(
          padding: EdgeInsets.all(8.0),
          child: CircularProgressIndicator(
            strokeWidth: 3.0,
          )),
      backgroundColor: Colors.white,
      elevation: 90.0,
      //insetAnimCurve: Curves.elasticInOut,
      progress: 0.0,
      maxProgress: 100.0,
      progressTextStyle: TextStyle(
          color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(
          color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600),
    );

    return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: Text('COVID-19 Live updates'),
          backgroundColor: Color(0xFF393359),
          centerTitle: true,
          elevation: 0.0,
        ),
        body: FutureBuilder(
          future: _api.getData(country.name),
          builder: (context, snapshot) {
            if (snapshot.data == null &&
                snapshot.connectionState == ConnectionState.active) {
              return Center(
                child: Text('Country data not found !'),
              );
            } else {
              if (snapshot.hasData) {
                final data = snapshot.data;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        margin: EdgeInsets.only(top: 0, bottom: 10.0),
                        height: 110.0,
                        alignment: Alignment.center,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(20.0),
                                  bottomRight: Radius.circular(20.0)),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage('assets/images/virusGif.gif'),
                              )),
                        )),
                    Container(
                      margin: EdgeInsets.only(
                          left: 10.0, right: 10.0, bottom: 10.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      child: ListView(
                        shrinkWrap: true,
                        padding: EdgeInsets.all(10.0),
                        children: <Widget>[
                          ListTile(
                              subtitle: Text(country.name.toUpperCase()),
                              title: Text(
                                'Country',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              trailing: Image(
                                image: NetworkImage(data.flag),
                                height: 40,
                              )),
                          Divider(),
                          ListTile(
                            title: Text(
                              'Cases',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            trailing: Text(
                              data.cases.toString(),
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Divider(),
                          ListTile(
                            title: Text(
                              'Cases today',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            trailing: Text(
                              data.todayCases.toString(),
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Divider(),
                          ListTile(
                            title: Text(
                              'Total Deaths',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            trailing: Text(
                              data.deaths.toString(),
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Divider(),
                          ListTile(
                            title: Text(
                              'Deaths today',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            trailing: Text(
                              data.todayDeaths.toString(),
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Divider(),
                          ListTile(
                            title: Text(
                              'Active cases',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            trailing: Text(
                              data.active.toString(),
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                );
              } else
                return Center(
                  child: CircularProgressIndicator(),
                );
            }
          },
        ),
        floatingActionButton: GestureDetector(
          onTap: () {
            countryPicker.launch(context);
          },
          child: Container(
            width: 125.0,
            height: 55.0,
            decoration: BoxDecoration(
                color: Color(0xFF393359),
                borderRadius: BorderRadius.all(Radius.circular(60.0))),
            child: Center(
                child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Text(
                'Pick a country',
                style: TextStyle(color: Colors.white),
              ),
            )),
          ),
        ));
  }
}
