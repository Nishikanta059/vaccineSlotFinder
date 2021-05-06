import 'dart:ui';

import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:dropdown_search/dropdown_search.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:vaccine_slot_finder/about.dart';
import 'package:vaccine_slot_finder/globalClass.dart';
import 'package:intl/intl.dart';
import 'package:vaccine_slot_finder/settings.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'vs finder',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> stateList = [];
  List<String> districtList = [];
  String selectedState;
  String selectedDist;
  String selectedPin;
  int _MinimunAgeForSearch = 18;
  DateTime selectedDate = DateTime.now();
  Country india;
  SelcState tempState;
  bool isSearching = false;
  bool isStateSelected = false;
  bool isStateLoaded = false;
  bool isDistLoaded = false;
  bool isSlotAvailable = false;
  bool isSlotAvailable2 = false;
  bool isSlotAvailable3 = false;
  bool isSlotAvailable4 = false;
  bool isSearchDone = false;
  bool isSearchStart = false;
  int availableSlots = 0;
  int availableSlots2 = 0;
  int availableSlots3 = 0;
  int availableSlots4 = 0;

  minAge _character;
  String _url = "https://selfregistration.cowin.gov.in/";
  @override
  void initState() {
    // TODO: implement initState
    initializeGlobalVariable();
    getStates();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var width = screenSize.width;
    return Scaffold(
      backgroundColor: Colors.pink[40],
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Find vaccine slots"),
        backgroundColor: Colors.purple[100],
        leading: TextButton.icon(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return About();
            }));
          },
          icon: Icon(
            Icons.anchor_outlined,
            color: Colors.blueGrey[900],
          ),
          label: Text(''),
        ),
        actions: [
          TextButton.icon(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return Settings(
                  sCountry: india,
                  sState: tempState,
                );
              }));
            },
            icon: Icon(
              Icons.settings,
              color: Colors.blueGrey[900],
            ),
            label: Text(''),
          )
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Colors.deepPurpleAccent[400],
            Colors.redAccent[400],
          ],
        )),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 30, 15, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  (deafultSearchMode == "pincode")
                      ? Center(
                          child: Container(
                            width: width / 2.5,
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: "pincode",
                                labelStyle: TextStyle(color: Colors.white),
                                fillColor: Colors.white,
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(
                                    color: Colors.blueGrey[900],
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(
                                    color: Colors.blueGrey[400],
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              keyboardType: TextInputType.number,
                              initialValue: deafaultPincode,
                              onChanged: (val) {
                                setState(() {
                                  selectedPin = val;
                                });
                              },
                            ),
                          ),
                        )
                      : Column(
                          children: [
                            isStateLoaded
                                ? DropdownSearch<String>(
                                    mode: Mode.MENU,
                                    showSelectedItem: true,
                                    showSearchBox: true,
                                    items: stateList,
                                    label: "Select State",
                                    hint: "country in menu mode",
                                    popupItemDisabled: (String s) =>
                                        s.startsWith('I'),
                                    onChanged: (val) {
                                      setState(() {
                                        selectedState = val;
                                        isDistLoaded = false;
                                        getDist();
                                      });
                                    },
                                    selectedItem: selectedState)
                                : CircularProgressIndicator(),
                            SizedBox(
                              height: 25,
                            ),
                            isStateLoaded
                                ? (isDistLoaded
                                    ? DropdownSearch<String>(
                                        mode: Mode.MENU,
                                        showSelectedItem: true,
                                        items: districtList,
                                        label: "select dist",
                                        hint: "select dist",
                                        popupItemDisabled: (String s) =>
                                            s.startsWith('I'),
                                        onChanged: (val) {
                                          setState(() {
                                            selectedDist = val;
                                          });
                                        },
                                        selectedItem: selectedDist,
                                      )
                                    : CircularProgressIndicator())
                                : SizedBox(
                                    height: 5,
                                  ),
                          ],
                        ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          new Radio(
                            value: minAge.age18to45,
                            groupValue: _character,
                            onChanged: (value) {
                              setState(() {
                                _character = value;
                                _MinimunAgeForSearch = 18;
                              });
                            },
                          ),
                          Flexible(
                            child: new Text(
                              'age18to45',
                              style: new TextStyle(fontSize: 16.0),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          new Radio(
                            value: minAge.ageAbove45,
                            groupValue: _character,
                            onChanged: (value) {
                              setState(() {
                                _character = value;
                                _MinimunAgeForSearch = 45;
                              });
                            },
                          ),
                          Flexible(
                            child: new Text(
                              'ageAbove45',
                              style: new TextStyle(
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      if (deafultSearchMode != "pincode") {
                        int tempDistID;

                        tempState.districts.forEach((element) {
                          if (selectedDist == element.districtName) {
                            tempDistID = element.districtId;
                          }
                        });
                        getCenterAvailBilityNsd(tempDistID);
                        getCenterAvailBilityNsd2(tempDistID);
                        getCenterAvailBilityNsd3(tempDistID);
                        getCenterAvailBilityNsd4(tempDistID);
                      } else {
                        getCenterAvailBilityNsdpin(int.parse(selectedPin));
                        getCenterAvailBilityNsdpin2(int.parse(selectedPin));
                        getCenterAvailBilityNsdpin3(int.parse(selectedPin));
                        getCenterAvailBilityNsdpin4(int.parse(selectedPin));
                      }

                      setState(() {
                        isSearchStart = true;
                      });
                    },
                    icon: Icon(
                      Icons.search,
                      color: Colors.white54,
                    ),
                    label: Text(
                      "start search",
                      style: TextStyle(color: Colors.white54),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.blueGrey[900]),
                    ),
                  ),
                  SizedBox(
                    height: 18,
                  ),
                  isSearchStart
                      ? CircularProgressIndicator()
                      : (!isSlotAvailable
                          ? Column(
                              children: [
                                Divider(),
                                Text('for next 7days form today'),
                                Divider(),
                                Text('slots available = $availableSlots')
                              ],
                            )
                          : Column(
                              children: [
                                Divider(),
                                Text('for next 7days form today'),
                                Divider(),
                                Text('slots available = $availableSlots'),
                                SizedBox(
                                  height: 20,
                                ),
                                TextButton(
                                  onPressed: _launchURL,
                                  child: Text('Book Now'),
                                ),
                              ],
                            )),
                  isSearchStart
                      ? CircularProgressIndicator()
                      : (!isSlotAvailable2
                          ? Column(
                              children: [
                                Divider(),
                                Text('for next 7-14 days form today'),
                                Divider(),
                                Text('slots available = $availableSlots2')
                              ],
                            )
                          : Column(
                              children: [
                                Divider(),
                                Text('for next 7-14 days form today'),
                                Divider(),
                                Text('slots available = $availableSlots2'),
                                SizedBox(
                                  height: 20,
                                ),
                                TextButton(
                                  onPressed: _launchURL,
                                  child: Text('Book Now'),
                                ),
                              ],
                            )),
                  isSearchStart
                      ? CircularProgressIndicator()
                      : (!isSlotAvailable3
                          ? Column(
                              children: [
                                Divider(),
                                Text('for next 14-21 days form today'),
                                Divider(),
                                Text('slots available = $availableSlots3')
                              ],
                            )
                          : Column(
                              children: [
                                Divider(),
                                Text('for next 14-21 days form today'),
                                Divider(),
                                Text('slots available = $availableSlots3'),
                                SizedBox(
                                  height: 20,
                                ),
                                TextButton(
                                  onPressed: _launchURL,
                                  child: Text('Book Now'),
                                ),
                              ],
                            )),
                  isSearchStart
                      ? CircularProgressIndicator()
                      : (!isSlotAvailable4
                          ? Column(
                              children: [
                                Divider(),
                                Text('for next 21-28 days form today'),
                                Divider(),
                                Text('slots available = $availableSlots4')
                              ],
                            )
                          : Column(
                              children: [
                                Divider(),
                                Text('for next 21-28 days form today'),
                                Divider(),
                                Text('slots available = $availableSlots4'),
                                SizedBox(
                                  height: 20,
                                ),
                                TextButton(
                                  onPressed: _launchURL,
                                  child: Text('Book Now'),
                                ),
                              ],
                            )),
                ],
              ),
            ),
          ),
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  getStates() async {
    var url =
        Uri.parse('https://cdn-api.co-vin.in/api/v2/admin/location/states');

    var response = await http.get(url);
    print("-----------response------");

    if (response.statusCode == 200) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;

      india = Country.fromJson(jsonResponse);
      print(india.states.length);
      india.states.forEach((state) {
        stateList.add(state.stateName);
      });
      setState(() {
        isStateLoaded = true;
        getDist();
      });
    } else {
      setState(() {
        isStateLoaded = true;
        getDist();
      });
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  getDist() async {
    print("------ddist-----");
    districtList.clear();
    int tempStateID;
    india.states.forEach((element) {
      if (selectedState == element.stateName) {
        tempStateID = element.stateId;
      }
    });

    var url = Uri.parse(
        'https://cdn-api.co-vin.in/api/v2/admin/location/districts/$tempStateID');

    var response = await http.get(url);
    print("-----------response------");

    if (response.statusCode == 200) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;

      tempState = SelcState.fromJson(jsonResponse);
      print(tempState.districts.length);
      tempState.districts.forEach((dist) {
        districtList.add(dist.districtName);
      });
      setState(() {
        isDistLoaded = true;
      });
    } else {
      setState(() {
        isDistLoaded = true;
      });
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  getCenterAvailBilityNsd(int distID) async {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    final String formatted = formatter.format(now);
    availableSlots = 0;
    isSlotAvailable = false;
    print(formatted);

    var url = Uri.parse(
        'https://cdn-api.co-vin.in/api/v2/appointment/sessions/public/calendarByDistrict?district_id=$distID&date=$formatted');

    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;

      DistCenters tempCenters = DistCenters.fromJson(jsonResponse);
      print(tempCenters.centers.length);
      tempCenters.centers.forEach((val) {
        val.sessions.forEach((element) {
          if (_MinimunAgeForSearch == element.minAgeLimit) {
            availableSlots += element.availableCapacity;
          }
        });
      });
      setState(() {
        if (availableSlots != 0) isSlotAvailable = true;

        isSearchStart = false;
      });
    } else {
      setState(() {
        isSearchStart = false;
      });
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  getCenterAvailBilityNsdpin(int pin) async {
    print("--------pin-------");
    print(pin.toString());
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    final String formatted = formatter.format(now);
    availableSlots = 0;
    isSlotAvailable = false;
    print(formatted);

    var url = Uri.parse(
        'https://cdn-api.co-vin.in/api/v2/appointment/sessions/public/calendarByPin?pincode=$pin&date=$formatted');

    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;

      DistCenters tempCenters = DistCenters.fromJson(jsonResponse);
      print(tempCenters.centers.length);
      tempCenters.centers.forEach((val) {
        val.sessions.forEach((element) {
          if (_MinimunAgeForSearch == element.minAgeLimit) {
            availableSlots += element.availableCapacity;
          }
        });
      });
      setState(() {
        if (availableSlots != 0) isSlotAvailable = true;

        isSearchStart = false;
      });
    } else {
      setState(() {
        isSearchStart = false;
      });
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  getCenterAvailBilityNsd2(int distID) async {
    final DateTime now = DateTime.now().add(const Duration(days: 7));
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    final String formatted = formatter.format(now);
    availableSlots2 = 0;
    isSlotAvailable2 = false;
    print(formatted);

    var url = Uri.parse(
        'https://cdn-api.co-vin.in/api/v2/appointment/sessions/public/calendarByDistrict?district_id=$distID&date=$formatted');

    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;

      DistCenters tempCenters2 = DistCenters.fromJson(jsonResponse);
      print(tempCenters2.centers.length);
      tempCenters2.centers.forEach((val) {
        val.sessions.forEach((element) {
          if (_MinimunAgeForSearch == element.minAgeLimit) {
            availableSlots2 += element.availableCapacity;
          }
        });
      });
      setState(() {
        if (availableSlots2 != 0) isSlotAvailable2 = true;

        isSearchStart = false;
      });
    } else {
      setState(() {
        isSearchStart = false;
      });
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  getCenterAvailBilityNsdpin2(int pin) async {
    final DateTime now = DateTime.now().add(const Duration(days: 7));
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    final String formatted = formatter.format(now);
    availableSlots2 = 0;
    isSlotAvailable2 = false;
    print(formatted);

    var url = Uri.parse(
        'https://cdn-api.co-vin.in/api/v2/appointment/sessions/public/calendarByPin?pincode=$pin&date=$formatted');

    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;

      DistCenters tempCenters2 = DistCenters.fromJson(jsonResponse);
      print(tempCenters2.centers.length);
      tempCenters2.centers.forEach((val) {
        val.sessions.forEach((element) {
          if (_MinimunAgeForSearch == element.minAgeLimit) {
            availableSlots2 += element.availableCapacity;
          }
        });
      });
      setState(() {
        if (availableSlots2 != 0) isSlotAvailable2 = true;

        isSearchStart = false;
      });
    } else {
      setState(() {
        isSearchStart = false;
      });
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  getCenterAvailBilityNsd3(int pin) async {
    final DateTime now = DateTime.now().add(const Duration(days: 14));
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    final String formatted = formatter.format(now);
    availableSlots3 = 0;
    isSlotAvailable3 = false;
    print(formatted);

    var url = Uri.parse(
        'https://cdn-api.co-vin.in/api/v2/appointment/sessions/public/calendarByPin?pincode=$pin&date=$formatted');

    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;

      DistCenters tempCenters3 = DistCenters.fromJson(jsonResponse);
      print(tempCenters3.centers.length);
      tempCenters3.centers.forEach((val) {
        val.sessions.forEach((element) {
          if (_MinimunAgeForSearch == element.minAgeLimit) {
            availableSlots3 += element.availableCapacity;
          }
        });
      });
      setState(() {
        if (availableSlots3 != 0) isSlotAvailable3 = true;

        isSearchStart = false;
      });
    } else {
      setState(() {
        isSearchStart = false;
      });
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  getCenterAvailBilityNsdpin3(int pin) async {
    final DateTime now = DateTime.now().add(const Duration(days: 14));
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    final String formatted = formatter.format(now);
    availableSlots3 = 0;
    isSlotAvailable3 = false;
    print(formatted);

    var url = Uri.parse(
        'https://cdn-api.co-vin.in/api/v2/appointment/sessions/public/calendarByPin?pincode=$pin&date=$formatted');

    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;

      DistCenters tempCenters3 = DistCenters.fromJson(jsonResponse);
      print(tempCenters3.centers.length);
      tempCenters3.centers.forEach((val) {
        val.sessions.forEach((element) {
          if (_MinimunAgeForSearch == element.minAgeLimit) {
            availableSlots3 += element.availableCapacity;
          }
        });
      });
      setState(() {
        if (availableSlots3 != 0) isSlotAvailable3 = true;

        isSearchStart = false;
      });
    } else {
      setState(() {
        isSearchStart = false;
      });
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  getCenterAvailBilityNsd4(int distID) async {
    final DateTime now = DateTime.now().add(const Duration(days: 21));
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    final String formatted = formatter.format(now);
    availableSlots4 = 0;
    isSlotAvailable4 = false;
    print(formatted);

    var url = Uri.parse(
        'https://cdn-api.co-vin.in/api/v2/appointment/sessions/public/calendarByDistrict?district_id=$distID&date=$formatted');

    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;

      DistCenters tempCenters4 = DistCenters.fromJson(jsonResponse);
      print(tempCenters4.centers.length);
      tempCenters4.centers.forEach((val) {
        val.sessions.forEach((element) {
          if (_MinimunAgeForSearch == element.minAgeLimit) {
            availableSlots4 += element.availableCapacity;
          }
        });
      });
      setState(() {
        if (availableSlots4 != 0) isSlotAvailable4 = true;

        isSearchStart = false;
      });
    } else {
      setState(() {
        isSearchStart = false;
      });
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  getCenterAvailBilityNsdpin4(int pin) async {
    final DateTime now = DateTime.now().add(const Duration(days: 21));
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    final String formatted = formatter.format(now);
    availableSlots4 = 0;
    isSlotAvailable4 = false;
    print(formatted);

    var url = Uri.parse(
        'https://cdn-api.co-vin.in/api/v2/appointment/sessions/public/calendarByPin?pincode=$pin&date=$formatted');

    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;

      DistCenters tempCenters4 = DistCenters.fromJson(jsonResponse);
      print(tempCenters4.centers.length);
      tempCenters4.centers.forEach((val) {
        val.sessions.forEach((element) {
          if (_MinimunAgeForSearch == element.minAgeLimit) {
            availableSlots4 += element.availableCapacity;
          }
        });
      });
      setState(() {
        if (availableSlots4 != 0) isSlotAvailable4 = true;

        isSearchStart = false;
      });
    } else {
      setState(() {
        isSearchStart = false;
      });
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  void _launchURL() async => await canLaunch(_url)
      ? await launch(_url)
      : throw 'Could not launch $_url';

  initializeGlobalVariable() {
    CookieManager tempCookie = CookieManager.getInstance();
    tempCookie.getCookie('deafultSearchMode') != ""
        ? deafultSearchMode = tempCookie.getCookie('deafultSearchMode')
        : null;
    tempCookie.getCookie('deafaultPincode') != ""
        ? deafaultPincode = tempCookie.getCookie('deafaultPincode')
        : null;
    tempCookie.getCookie('defaultState') != ""
        ? defaultState = tempCookie.getCookie('defaultState')
        : null;
    tempCookie.getCookie('defaultDist') != ""
        ? defaultDist = tempCookie.getCookie('defaultDist')
        : null;
    tempCookie.getCookie('dafaultStateID') != ""
        ? dafaultStateID = tempCookie.getCookie('dafaultStateID')
        : null;
    tempCookie.getCookie('defaultDistID') != ""
        ? dafaultStateID = tempCookie.getCookie('defaultDistID')
        : null;
    tempCookie.getCookie('deafultAgeGroup') != ""
        ? deafultAgeGroup = tempCookie.getCookie('deafultAgeGroup')
        : null;

    selectedState = defaultState;
    selectedDist = defaultDist;
    selectedPin = deafaultPincode;
    _character = EnumToString.fromString(minAge.values, deafultAgeGroup);
  }
}
