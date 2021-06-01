import 'dart:ui';

import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:dropdown_search/dropdown_search.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
      // home: CountDownTimer(),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

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
  int _MinimunAgeForSearch;
  String _DoseForSearch;
  DateTime selectedDate = DateTime.now();
  Country india;
  SelcState tempState;
  bool isSearching = false;
  bool isStateSelected = false;
  bool isStateLoaded = false;
  bool isDistLoaded = false;
  static bool isSlotAvailable1 = false;
  static bool isSlotAvailable2 = false;
  static bool isSlotAvailable3 = false;
  static bool isSlotAvailable4 = false;
  static bool isSlotAvailabled = false;
  // static bool isSearchDone = false;
  // static bool isSearchStart = false;
  static int availableSlots1 = 0;
  static int availableSlots2 = 0;
  static int availableSlots3 = 0;
  static int availableSlots4 = 0;
  static int availableSlotsd = 0;
  static int availableSlots1d1 = 0;
  static int availableSlots2d1 = 0;
  static int availableSlots3d1 = 0;
  static int availableSlots4d1 = 0;
  int availableSlotsdd1 = 0;
  static int availableSlots1d2 = 0;
  static int availableSlots2d2 = 0;
  static int availableSlots3d2 = 0;
  static int availableSlots4d2 = 0;
  int availableSlotsdd2 = 0;

  static DistCenters tempCenters1, tempCenters2, tempCenters3, tempCenters4;
  var availableSlots = [
    availableSlots1,
    availableSlots2,
    availableSlots3,
    availableSlots4
  ];
  var availableSlotsd1 = [
    availableSlots1d1,
    availableSlots2d1,
    availableSlots3d1,
    availableSlots4d1
  ];
  var availableSlotsd2 = [
    availableSlots1d2,
    availableSlots2d2,
    availableSlots3d2,
    availableSlots4d2
  ];
  var isSlotAvailable = [
    isSlotAvailable1,
    isSlotAvailable2,
    isSlotAvailable3,
    isSlotAvailable4
  ];
  var tempCenters = [tempCenters1, tempCenters2, tempCenters3, tempCenters4];

  minAge _character;
  dose _dose;
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
    print("----==refresh==-------");
    // print("-----------slot------test------" + availableSlots[0].toString());
    // print("-----------slot------testd1------" + availableSlotsd1[0].toString());
    // print("-----------slot------testd2------" + availableSlotsd2[0].toString());
    // print(isSearchStart.toString());
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
            Colors.pink[200],
          ],
        )),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
          child: Scrollbar(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 30, 15, 0),
                child: isNoticeActive != "true"
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          (deafultSearchMode == "pincode")
                              ? Center(
                                  child: Container(
                                    width: width / 2.5,
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                        labelText: "pincode",
                                        labelStyle:
                                            TextStyle(color: Colors.white),
                                        fillColor: Colors.white,
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          borderSide: BorderSide(
                                            color: Colors.blueGrey[900],
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
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
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  new Radio(
                                    value: dose.dose1,
                                    groupValue: _dose,
                                    onChanged: (value) {
                                      setState(() {
                                        _dose = value;
                                        _DoseForSearch = "dose1";
                                      });
                                    },
                                  ),
                                  Flexible(
                                    child: new Text(
                                      'Dose 1',
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
                                    value: dose.dose2,
                                    groupValue: _dose,
                                    onChanged: (value) {
                                      setState(() {
                                        _dose = value;
                                        _DoseForSearch = "dose2";
                                      });
                                    },
                                  ),
                                  Flexible(
                                    child: new Text(
                                      'Dose 2',
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
                            height: 25,
                          ),
                          ElevatedButton.icon(
                            onPressed: () async {
                              if (deafultSearchMode != "pincode") {
                                int tempDistID;

                                tempState.districts.forEach((element) {
                                  if (selectedDist == element.districtName) {
                                    tempDistID = element.districtId;
                                  }
                                });
                                await getCenterAvailBilityNsdF(tempDistID);
                                // await getCenterAvailBilityNsd2(tempDistID);
                                // await getCenterAvailBilityNsd3(tempDistID);
                                // await getCenterAvailBilityNsd4(tempDistID);
                                getCenterAvailBilityDR();
                              } else {
                                await getCenterAvailBilityNsdpinF(
                                    int.parse(selectedPin));
                                // await getCenterAvailBilityNsdpin2(
                                //     int.parse(selectedPin));
                                // await getCenterAvailBilityNsdpin3(
                                //     int.parse(selectedPin));
                                // await getCenterAvailBilityNsdpin4(
                                //     int.parse(selectedPin));
                                getCenterAvailBilityDR();
                              }

                              Fluttertoast.showToast(msg: "searching..");
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
                          // isSearchStart
                          //     ? CircularProgressIndicator()
                          //     :
                          (!isSlotAvailabled
                              ? Column(
                                  children: [
                                    Divider(),
                                    Text("from  " +
                                        DateFormat('dd-MM-yyyy').format(
                                            DateTime.parse(autoRunStartDate)) +
                                        " to " +
                                        DateFormat('dd-MM-yyyy').format(
                                            DateTime.parse(autoRunEndDate))),
                                    Divider(),
                                    Text(
                                        'total slots available = $availableSlotsd')
                                  ],
                                )
                              : Column(
                                  children: [
                                    Divider(),
                                    Text("from  " +
                                        DateFormat('dd-MM-yyyy').format(
                                            DateTime.parse(autoRunStartDate)) +
                                        " to " +
                                        DateFormat('dd-MM-yyyy').format(
                                            DateTime.parse(autoRunEndDate))),
                                    Divider(),
                                    Wrap(
                                      spacing: 10,
                                      children: [
                                        Text(
                                            'Dose 1 slots = ' +
                                                availableSlotsdd1.toString(),
                                            style: TextStyle(
                                                color: Colors.lightGreen)),
                                        Text(
                                            'Dose 2 slots = ' +
                                                availableSlotsdd2.toString(),
                                            style: TextStyle(
                                                color: Colors.greenAccent)),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    _DoseForSearch == "dose1" &&
                                                availableSlotsdd1 != 0 ||
                                            _DoseForSearch == "dose2" &&
                                                availableSlotsdd2 != 0
                                        ? TextButton(
                                            onPressed: _launchURL,
                                            child: Text('Book Now'),
                                          )
                                        : SizedBox.shrink(),
                                  ],
                                )),
                          SizedBox(
                            height: 18,
                          ),
                          // isSearchStart
                          //     ? CircularProgressIndicator()
                          //     :
                          (!isSlotAvailable[0]
                              ? Column(
                                  children: [
                                    Divider(),
                                    Text('for next 7days form today'),
                                    Divider(),
                                    Text('total slots available = ' +
                                        availableSlots[0].toString())
                                  ],
                                )
                              : Column(
                                  children: [
                                    Divider(),
                                    Text('for next 7days form today'),
                                    Divider(),
                                    Wrap(
                                      spacing: 10,
                                      children: [
                                        Text(
                                            'Dose 1 slots = ' +
                                                availableSlotsd1[0].toString(),
                                            style: TextStyle(
                                                color: Colors.lightGreen)),
                                        Text(
                                            'Dose 2 slots = ' +
                                                availableSlotsd2[0].toString(),
                                            style: TextStyle(
                                                color: Colors.greenAccent)),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    _DoseForSearch == "dose1" &&
                                                availableSlotsd1[0] != 0 ||
                                            _DoseForSearch == "dose2" &&
                                                availableSlotsd2[0] != 0
                                        ? TextButton(
                                            onPressed: _launchURL,
                                            child: Text('Book Now'),
                                          )
                                        : SizedBox.shrink(),
                                  ],
                                )),
                          // isSearchStart
                          //     ? CircularProgressIndicator()
                          //     :
                          (!isSlotAvailable[1]
                              ? Column(
                                  children: [
                                    Divider(),
                                    Text('for next 7-14 days form today'),
                                    Divider(),
                                    Text(
                                        'total slots available = $availableSlots2')
                                  ],
                                )
                              : Column(
                                  children: [
                                    Divider(),
                                    Text('for next 7-14 days form today'),
                                    Divider(),
                                    Wrap(
                                      spacing: 10,
                                      children: [
                                        Text(
                                            'Dose 1 slots = ' +
                                                availableSlotsd1[1].toString(),
                                            style: TextStyle(
                                                color: Colors.lightGreen)),
                                        Text(
                                            'Dose 2 slots = ' +
                                                availableSlotsd2[1].toString(),
                                            style: TextStyle(
                                                color: Colors.greenAccent)),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    _DoseForSearch == "dose1" &&
                                                availableSlotsd1[1] != 0 ||
                                            _DoseForSearch == "dose2" &&
                                                availableSlotsd2[1] != 0
                                        ? TextButton(
                                            onPressed: _launchURL,
                                            child: Text('Book Now'),
                                          )
                                        : SizedBox.shrink(),
                                  ],
                                )),
                          // isSearchStart
                          //     ? CircularProgressIndicator()
                          //     :
                          (!isSlotAvailable[2]
                              ? Column(
                                  children: [
                                    Divider(),
                                    Text('for next 14-21 days form today'),
                                    Divider(),
                                    Text(
                                        'total slots available = $availableSlots3')
                                  ],
                                )
                              : Column(
                                  children: [
                                    Divider(),
                                    Text('for next 14-21 days form today'),
                                    Divider(),
                                    Wrap(
                                      spacing: 10,
                                      children: [
                                        Text(
                                            'Dose 1 slots = ' +
                                                availableSlotsd1[2].toString(),
                                            style: TextStyle(
                                                color: Colors.lightGreen)),
                                        Text(
                                            'Dose 2 slots = ' +
                                                availableSlotsd2[2].toString(),
                                            style: TextStyle(
                                                color: Colors.greenAccent)),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    _DoseForSearch == "dose1" &&
                                                availableSlotsd1[2] != 0 ||
                                            _DoseForSearch == "dose2" &&
                                                availableSlotsd2[2] != 0
                                        ? TextButton(
                                            onPressed: _launchURL,
                                            child: Text('Book Now'),
                                          )
                                        : SizedBox.shrink(),
                                  ],
                                )),
                          // isSearchStart
                          //     ? CircularProgressIndicator()
                          //     :
                          (!isSlotAvailable[3]
                              ? Column(
                                  children: [
                                    Divider(),
                                    Text('for next 21-28 days form today'),
                                    Divider(),
                                    Text(
                                        'total slots available = $availableSlots4')
                                  ],
                                )
                              : Column(
                                  children: [
                                    Divider(),
                                    Text('for next 21-28 days form today'),
                                    Divider(),
                                    Wrap(
                                      spacing: 10,
                                      children: [
                                        Text(
                                            'Dose 1 slots = ' +
                                                availableSlotsd1[3].toString(),
                                            style: TextStyle(
                                                color: Colors.lightGreen)),
                                        Text(
                                            'Dose 2 slots = ' +
                                                availableSlotsd2[3].toString(),
                                            style: TextStyle(
                                                color: Colors.greenAccent)),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    _DoseForSearch == "dose1" &&
                                                availableSlotsd1[3] != 0 ||
                                            _DoseForSearch == "dose2" &&
                                                availableSlotsd2[3] != 0
                                        ? TextButton(
                                            onPressed: _launchURL,
                                            child: Text('Book Now'),
                                          )
                                        : SizedBox.shrink(),
                                  ],
                                )),
                        ],
                      )
                    : Center(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                          child: AlertDialog(
                            title: Text("NOTICE"),
                            content: Text(
                                "As per the new rules of Ministry of Health and Family Welfare , the appointment availability data is cached and may be upto 30 minutes old .\n \n \nUse the 'install app' or 'add to home screen' options available in the more section of your browser to use this site as an app."),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    dismisNotice();
                                  },
                                  child: Text("ok"))
                            ],
                          ),
                        ),
                      ),
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

  getCenterAvailBilityNsdF(int distID) async {
    for (int z = 0; z <= 3; z++) {
      final DateTime now = DateTime.now().add(Duration(days: 7 * z));
      final DateFormat formatter = DateFormat('dd-MM-yyyy');
      final String formatted = formatter.format(now);
      availableSlots[z] = 0;
      availableSlotsd1[z] = 0;
      availableSlotsd2[z] = 0;
      isSlotAvailable[z] = false;
      print("nsd+$z");
      print(formatted);

      var url = Uri.parse(
          'https://cdn-api.co-vin.in/api/v2/appointment/sessions/public/calendarByDistrict?district_id=$distID&date=$formatted');

      var response = await http.get(url);
      if (response.statusCode == 200) {
        var jsonResponse =
            convert.jsonDecode(response.body) as Map<String, dynamic>;

        tempCenters[z] = DistCenters.fromJson(jsonResponse);
        print(tempCenters[z].centers.length);
        tempCenters[z].centers.forEach((val) {
          val.sessions.forEach((element) {
            if (_MinimunAgeForSearch == element.minAgeLimit) {
              availableSlots[z] += element.availableCapacity;

              availableSlotsd1[z] += element.availableCapacityDose1;
              availableSlotsd2[z] += element.availableCapacityDose2;
            }
          });
        });
        setState(() {
          if (availableSlots[z] != 0) isSlotAvailable[z] = true;

          // isSearchStart = false;
        });
        print("-----------slot------$z------" + availableSlots[z].toString());
      } else {
        setState(() {
          // isSearchStart = false;
        });
        print('Request failed with status: ${response.statusCode}.');
      }
    }
  }

  getCenterAvailBilityNsdpinF(int pin) async {
    for (int z = 0; z <= 3; z++) {
      print("--------pin-------");
      print(pin.toString());
      final DateTime now = DateTime.now().add(Duration(days: 7 * z));
      final DateFormat formatter = DateFormat('dd-MM-yyyy');
      final String formatted = formatter.format(now);
      availableSlots[z] = 0;
      availableSlotsd1[z] = 0;
      availableSlotsd2[z] = 0;
      isSlotAvailable[z] = false;
      print(formatted);

      var url = Uri.parse(
          'https://cdn-api.co-vin.in/api/v2/appointment/sessions/public/calendarByPin?pincode=$pin&date=$formatted');

      var response = await http.get(url);
      if (response.statusCode == 200) {
        var jsonResponse =
            convert.jsonDecode(response.body) as Map<String, dynamic>;

        tempCenters[z] = DistCenters.fromJson(jsonResponse);
        print(tempCenters[z].centers.length);
        tempCenters[z].centers.forEach((val) {
          val.sessions.forEach((element) {
            if (_MinimunAgeForSearch == element.minAgeLimit) {
              availableSlots[z] += element.availableCapacity;

              availableSlotsd1[z] += element.availableCapacityDose1;
              availableSlotsd2[z] += element.availableCapacityDose2;
            }
          });
        });
        setState(() {
          if (availableSlots[z] != 0) isSlotAvailable[z] = true;

          // isSearchStart = false;
        });
        print(
            "-----------slot pin------$z------" + availableSlots[z].toString());
      } else {
        setState(() {
          // isSearchStart = false;
        });
        print('Request failed with status: ${response.statusCode}.');
      }
    }
  }
  // getCenterAvailBilityNsd(int distID) async {
  //   final DateTime now = DateTime.now();
  //   final DateFormat formatter = DateFormat('dd-MM-yyyy');
  //   final String formatted = formatter.format(now);
  //   availableSlots1 = 0;
  //   availableSlots1d2 = 0;
  //   availableSlots1d1 = 0;
  //   isSlotAvailable1 = false;
  //   print("nsd 1");
  //   print(formatted);
  //
  //   var url = Uri.parse(
  //       'https://cdn-api.co-vin.in/api/v2/appointment/sessions/public/calendarByDistrict?district_id=$distID&date=$formatted');
  //
  //   var response = await http.get(url);
  //   if (response.statusCode == 200) {
  //     var jsonResponse =
  //     convert.jsonDecode(response.body) as Map<String, dynamic>;
  //
  //     tempCenters = DistCenters.fromJson(jsonResponse);
  //     print(tempCenters.centers.length);
  //     tempCenters.centers.forEach((val) {
  //       val.sessions.forEach((element) {
  //         if (_MinimunAgeForSearch == element.minAgeLimit) {
  //           availableSlots1 += element.availableCapacity;
  //           availableSlots1d1 += element.availableCapacityDose1;
  //           availableSlots1d2 += element.availableCapacityDose2;
  //         }
  //       });
  //     });
  //     setState(() {
  //       if (availableSlots1 != 0) isSlotAvailable1 = true;
  //
  //       // isSearchStart = false;
  //     });
  //   } else {
  //     setState(() {
  //       // isSearchStart = false;
  //     });
  //     print('Request failed with status: ${response.statusCode}.');
  //   }
  // }
  // getCenterAvailBilityNsdpin(int pin) async {
  //   print("--------pin-------");
  //   print(pin.toString());
  //   final DateTime now = DateTime.now();
  //   final DateFormat formatter = DateFormat('dd-MM-yyyy');
  //   final String formatted = formatter.format(now);
  //   availableSlots1 = 0;
  //   isSlotAvailable1 = false;
  //   print(formatted);
  //
  //   var url = Uri.parse(
  //       'https://cdn-api.co-vin.in/api/v2/appointment/sessions/public/calendarByPin?pincode=$pin&date=$formatted');
  //
  //   var response = await http.get(url);
  //   if (response.statusCode == 200) {
  //     var jsonResponse =
  //         convert.jsonDecode(response.body) as Map<String, dynamic>;
  //
  //     tempCenters = DistCenters.fromJson(jsonResponse);
  //     print(tempCenters.centers.length);
  //     tempCenters.centers.forEach((val) {
  //       val.sessions.forEach((element) {
  //         if (_MinimunAgeForSearch == element.minAgeLimit) {
  //           availableSlots1 += element.availableCapacity;
  //         }
  //       });
  //     });
  //     setState(() {
  //       if (availableSlots1 != 0) isSlotAvailable1 = true;
  //
  //       // isSearchStart = false;
  //     });
  //   } else {
  //     setState(() {
  //       // isSearchStart = false;
  //     });
  //     print('Request failed with status: ${response.statusCode}.');
  //   }
  // }

  // getCenterAvailBilityNsd2(int distID) async {
  //   final DateTime now = DateTime.now().add(const Duration(days: 7));
  //   final DateFormat formatter = DateFormat('dd-MM-yyyy');
  //   final String formatted = formatter.format(now);
  //   availableSlots2 = 0;
  //   isSlotAvailable2 = false;
  //   print("nsd2");
  //   print(formatted);
  //
  //   var url = Uri.parse(
  //       'https://cdn-api.co-vin.in/api/v2/appointment/sessions/public/calendarByDistrict?district_id=$distID&date=$formatted');
  //
  //   var response = await http.get(url);
  //   if (response.statusCode == 200) {
  //     var jsonResponse =
  //         convert.jsonDecode(response.body) as Map<String, dynamic>;
  //
  //     tempCenters2 = DistCenters.fromJson(jsonResponse);
  //     print(tempCenters2.centers.length);
  //     tempCenters2.centers.forEach((val) {
  //       val.sessions.forEach((element) {
  //         if (_MinimunAgeForSearch == element.minAgeLimit) {
  //           availableSlots2 += element.availableCapacity;
  //         }
  //       });
  //     });
  //     setState(() {
  //       if (availableSlots2 != 0) isSlotAvailable2 = true;
  //
  //       // isSearchStart = false;
  //     });
  //   } else {
  //     setState(() {
  //       // isSearchStart = false;
  //     });
  //     print('Request failed with status: ${response.statusCode}.');
  //   }
  // }
  //
  // getCenterAvailBilityNsdpin2(int pin) async {
  //   final DateTime now = DateTime.now().add(const Duration(days: 7));
  //   final DateFormat formatter = DateFormat('dd-MM-yyyy');
  //   final String formatted = formatter.format(now);
  //   availableSlots2 = 0;
  //   isSlotAvailable2 = false;
  //   print(formatted);
  //
  //   var url = Uri.parse(
  //       'https://cdn-api.co-vin.in/api/v2/appointment/sessions/public/calendarByPin?pincode=$pin&date=$formatted');
  //
  //   var response = await http.get(url);
  //   if (response.statusCode == 200) {
  //     var jsonResponse =
  //         convert.jsonDecode(response.body) as Map<String, dynamic>;
  //
  //     tempCenters2 = DistCenters.fromJson(jsonResponse);
  //     print(tempCenters2.centers.length);
  //     tempCenters2.centers.forEach((val) {
  //       val.sessions.forEach((element) {
  //         if (_MinimunAgeForSearch == element.minAgeLimit) {
  //           availableSlots2 += element.availableCapacity;
  //         }
  //       });
  //     });
  //     setState(() {
  //       if (availableSlots2 != 0) isSlotAvailable2 = true;
  //
  //       // isSearchStart = false;
  //     });
  //   } else {
  //     setState(() {
  //       // isSearchStart = false;
  //     });
  //     print('Request failed with status: ${response.statusCode}.');
  //   }
  // }
  //
  // getCenterAvailBilityNsd3(int distID) async {
  //   final DateTime now = DateTime.now().add(const Duration(days: 14));
  //   final DateFormat formatter = DateFormat('dd-MM-yyyy');
  //   final String formatted = formatter.format(now);
  //   availableSlots3 = 0;
  //   isSlotAvailable3 = false;
  //   print("nsd3");
  //   print(formatted);
  //
  //   var url = Uri.parse(
  //       'https://cdn-api.co-vin.in/api/v2/appointment/sessions/public/calendarByDistrict?district_id=$distID&date=$formatted');
  //
  //   var response = await http.get(url);
  //   if (response.statusCode == 200) {
  //     var jsonResponse =
  //         convert.jsonDecode(response.body) as Map<String, dynamic>;
  //
  //     tempCenters3 = DistCenters.fromJson(jsonResponse);
  //     print(tempCenters3.centers.length);
  //     tempCenters3.centers.forEach((val) {
  //       val.sessions.forEach((element) {
  //         if (_MinimunAgeForSearch == element.minAgeLimit) {
  //           availableSlots3 += element.availableCapacity;
  //         }
  //       });
  //     });
  //     setState(() {
  //       if (availableSlots3 != 0) isSlotAvailable3 = true;
  //
  //       // isSearchStart = false;
  //     });
  //   } else {
  //     setState(() {
  //       // isSearchStart = false;
  //     });
  //     print('Request failed with status: ${response.statusCode}.');
  //   }
  // }
  //
  // getCenterAvailBilityNsdpin3(int pin) async {
  //   final DateTime now = DateTime.now().add(const Duration(days: 14));
  //   final DateFormat formatter = DateFormat('dd-MM-yyyy');
  //   final String formatted = formatter.format(now);
  //   availableSlots3 = 0;
  //   isSlotAvailable3 = false;
  //   print(formatted);
  //
  //   var url = Uri.parse(
  //       'https://cdn-api.co-vin.in/api/v2/appointment/sessions/public/calendarByPin?pincode=$pin&date=$formatted');
  //
  //   var response = await http.get(url);
  //   if (response.statusCode == 200) {
  //     var jsonResponse =
  //         convert.jsonDecode(response.body) as Map<String, dynamic>;
  //
  //     tempCenters3 = DistCenters.fromJson(jsonResponse);
  //     print(tempCenters3.centers.length);
  //     tempCenters3.centers.forEach((val) {
  //       val.sessions.forEach((element) {
  //         if (_MinimunAgeForSearch == element.minAgeLimit) {
  //           availableSlots3 += element.availableCapacity;
  //         }
  //       });
  //     });
  //     setState(() {
  //       if (availableSlots3 != 0) isSlotAvailable3 = true;
  //
  //       // isSearchStart = false;
  //     });
  //   } else {
  //     setState(() {
  //       // isSearchStart = false;
  //     });
  //     print('Request failed with status: ${response.statusCode}.');
  //   }
  // }
  //
  // getCenterAvailBilityNsd4(int distID) async {
  //   final DateTime now = DateTime.now().add(const Duration(days: 21));
  //   final DateFormat formatter = DateFormat('dd-MM-yyyy');
  //   final String formatted = formatter.format(now);
  //   availableSlots4 = 0;
  //   isSlotAvailable4 = false;
  //   print(formatted);
  //   print("nsd3");
  //
  //   var url = Uri.parse(
  //       'https://cdn-api.co-vin.in/api/v2/appointment/sessions/public/calendarByDistrict?district_id=$distID&date=$formatted');
  //
  //   var response = await http.get(url);
  //   if (response.statusCode == 200) {
  //     var jsonResponse =
  //         convert.jsonDecode(response.body) as Map<String, dynamic>;
  //
  //     tempCenters4 = DistCenters.fromJson(jsonResponse);
  //     print(tempCenters4.centers.length);
  //     tempCenters4.centers.forEach((val) {
  //       val.sessions.forEach((element) {
  //         if (_MinimunAgeForSearch == element.minAgeLimit) {
  //           availableSlots4 += element.availableCapacity;
  //         }
  //       });
  //     });
  //     setState(() {
  //       if (availableSlots4 != 0) isSlotAvailable4 = true;
  //
  //       // isSearchStart = false;
  //     });
  //   } else {
  //     setState(() {
  //       // isSearchStart = false;
  //     });
  //     print('Request failed with status: ${response.statusCode}.');
  //   }
  // }
  //
  // getCenterAvailBilityNsdpin4(int pin) async {
  //   final DateTime now = DateTime.now().add(const Duration(days: 21));
  //   final DateFormat formatter = DateFormat('dd-MM-yyyy');
  //   final String formatted = formatter.format(now);
  //   availableSlots4 = 0;
  //   isSlotAvailable4 = false;
  //   print(formatted);
  //
  //   var url = Uri.parse(
  //       'https://cdn-api.co-vin.in/api/v2/appointment/sessions/public/calendarByPin?pincode=$pin&date=$formatted');
  //
  //   var response = await http.get(url);
  //   if (response.statusCode == 200) {
  //     var jsonResponse =
  //         convert.jsonDecode(response.body) as Map<String, dynamic>;
  //
  //     tempCenters4 = DistCenters.fromJson(jsonResponse);
  //     print(tempCenters4.centers.length);
  //     tempCenters4.centers.forEach((val) {
  //       val.sessions.forEach((element) {
  //         if (_MinimunAgeForSearch == element.minAgeLimit) {
  //           availableSlots4 += element.availableCapacity;
  //         }
  //       });
  //     });
  //     setState(() {
  //       if (availableSlots4 != 0) isSlotAvailable4 = true;
  //
  //       // isSearchStart = false;
  //     });
  //   } else {
  //     setState(() {
  //       // isSearchStart = false;
  //     });
  //     print('Request failed with status: ${response.statusCode}.');
  //   }
  // }

  getCenterAvailBilityDR() {
    availableSlotsd = 0;
    availableSlotsdd1 = 0;
    availableSlotsdd2 = 0;

    isSlotAvailabled = false;

    for (int z = 0; z <= 3; z++) {
      tempCenters[z].centers.forEach((val) {
        val.sessions.forEach((element) {
          String tempDate = element.date;
          String formatedTempDate = tempDate.split("-")[2] +
              "-" +
              tempDate.split("-")[1] +
              "-" +
              tempDate.split("-")[0];
          DateTime sessionDate = DateTime.parse(formatedTempDate);
          DateTime DRstartDate = DateTime.parse(autoRunStartDate);
          DateTime DRendDate = DateTime.parse(autoRunEndDate);

          if (_MinimunAgeForSearch == element.minAgeLimit &&
              (sessionDate.compareTo(DRstartDate) >= 0) &&
              (DRendDate.compareTo(sessionDate) >= 0)) {
            availableSlotsd += element.availableCapacity;
            availableSlotsdd1 += element.availableCapacityDose1;
            availableSlotsdd2 += element.availableCapacityDose2;
          }
        });
      });
    }

    // tempCenters[1].centers.forEach((val) {
    //   val.sessions.forEach((element) {
    //     String tempDate = element.date;
    //     String formatedTempDate = tempDate.split("-")[2] +
    //         "-" +
    //         tempDate.split("-")[1] +
    //         "-" +
    //         tempDate.split("-")[0];
    //     DateTime sessionDate = DateTime.parse(formatedTempDate);
    //     DateTime DRstartDate = DateTime.parse(autoRunStartDate);
    //     DateTime DRendDate = DateTime.parse(autoRunEndDate);
    //
    //     if (_MinimunAgeForSearch == element.minAgeLimit &&
    //         (sessionDate.compareTo(DRstartDate) >= 0) &&
    //         (DRendDate.compareTo(sessionDate) >= 0)) {
    //       availableSlotsd += element.availableCapacity;
    //     }
    //   });
    // });
    //
    //
    setState(() {
      if (availableSlotsd != 0) isSlotAvailabled = true;
      // isSearchStart = false;
      // print("----=====");
      // print(isSearchStart.toString());
    });
  }

  void _launchURL() async => await canLaunch(_url)
      ? await launch(_url)
      : throw 'Could not launch $_url';

  dismisNotice() async {
    CookieManager tempCookie = CookieManager.getInstance();

    setState(() {
      isNoticeActive = "false";
    });
    tempCookie.addToCookie('isNoticeActive', isNoticeActive);
  }

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
    tempCookie.getCookie('deafultDose') != ""
        ? deafultDose = tempCookie.getCookie('deafultDose')
        : null;
    tempCookie.getCookie('autoRunStartDate') != ""
        ? autoRunStartDate = tempCookie.getCookie('autoRunStartDate')
        : autoRunStartDate = DateTime.now().toString();
    tempCookie.getCookie('autoRunEndDate') != ""
        ? autoRunEndDate = tempCookie.getCookie('autoRunEndDate')
        : autoRunEndDate = DateTime.now().toString();
    tempCookie.getCookie('isNoticeActive') != ""
        ? isNoticeActive = tempCookie.getCookie('isNoticeActive')
        : null;
    // tempCookie.getCookie('aRReRunTimeInMin') != ""
    //     ? aRReRunTimeInMin = tempCookie.getCookie('aRReRunTimeInMin')
    //     : null;
    // autoRunStartDate = DateTime.now().toString();
    // autoRunEndDate = DateTime.now().toString();
    selectedState = defaultState;
    selectedDist = defaultDist;
    selectedPin = deafaultPincode;
    _MinimunAgeForSearch = (deafultAgeGroup == "ageAbove45" ? 45 : 18);
    _DoseForSearch = (deafultDose == "dose1" ? "dose1" : "dose2");
    _character = EnumToString.fromString(minAge.values, deafultAgeGroup);
    _dose = EnumToString.fromString(dose.values, deafultDose);
  }
}
