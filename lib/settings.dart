import 'dart:html' as html;

import 'package:dropdown_search/dropdown_search.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import 'package:vaccine_slot_finder/globalClass.dart';
import 'dart:ui';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class Settings extends StatefulWidget {
  final Country sCountry;
  final SelcState sState;
  const Settings({@required this.sCountry, @required this.sState});

  @override
  _SettingsState createState() => _SettingsState();
}

enum searchBy { pincode, district }

class _SettingsState extends State<Settings> {
  List<String> stateList = [];
  List<String> districtList = [];
  searchBy _radio = EnumToString.fromString(searchBy.values, deafultSearchMode);
  minAge _characters = EnumToString.fromString(minAge.values, deafultAgeGroup);
  dose _dose = EnumToString.fromString(dose.values, deafultDose);
  SelcState tempState;
  bool isStateLoaded = true;
  bool isDistLoaded = true;
  bool isSaveStrart = false;
  DateTime selectedStartDate = DateTime.now();
  DateTime selectedEndDate = DateTime.now();
  @override
  void initState() {
    // TODO: implement initState
    widget.sCountry.states.forEach((state) {
      stateList.add(state.stateName);
    });
    widget.sState.districts.forEach((dist) {
      districtList.add(dist.districtName);
    });
    tempState = widget.sState;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var width = screenSize.width;
    return Scaffold(
        backgroundColor: Colors.pink[50],
        appBar: AppBar(
          backgroundColor: Colors.purple[100],
          title: Text('settings'),
          actions: [
            isSaveStrart
                ? CircularProgressIndicator()
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.white54),
                      ),
                      onPressed: () {
                        tempState.districts.forEach((element) {
                          if (defaultDist == element.districtName) {
                            defaultDistID = element.districtId.toString();
                          }
                        });
                        widget.sCountry.states.forEach((state) {
                          if (defaultState == state.stateName) {
                            defaultDistID = state.stateId.toString();
                          }
                        });
                        setState(() {
                          isSaveStrart = true;
                          saveToLocal();
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                        child: Text(
                          "save changes",
                          style: TextStyle(
                            color: Colors.blueGrey[900],
                          ),
                        ),
                      ),
                    ),
                  ),
          ],
        ),
        body: RawScrollbar(
          isAlwaysShown: true,
          thumbColor: Colors.blueGrey[800],
          radius: Radius.circular(20),
          thickness: 8,
          child: SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Colors.deepPurpleAccent[400],
                  Colors.pink[200],
                ],
              )),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                child: Column(
                  children: [
                    BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(15, 30, 15, 0),
                          child: Column(
                            children: [
                              Center(child: Text("Search mode")),
                              Divider(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      new Radio(
                                        value: searchBy.pincode,
                                        groupValue: _radio,
                                        onChanged: (value) {
                                          setState(() {
                                            _radio = value;
                                            deafultSearchMode = 'pincode';
                                          });
                                        },
                                      ),
                                      Flexible(
                                        child: new Text(
                                          'pincode',
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
                                        value: searchBy.district,
                                        groupValue: _radio,
                                        onChanged: (value) {
                                          setState(() {
                                            _radio = value;
                                            deafultSearchMode = 'district';
                                          });
                                        },
                                      ),
                                      Flexible(
                                        child: new Text(
                                          'district',
                                          style: new TextStyle(
                                            fontSize: 16.0,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Column(
                      children: [
                        Center(child: Text("Age group")),
                        Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                new Radio(
                                  value: minAge.age18to45,
                                  groupValue: _characters,
                                  onChanged: (value) {
                                    setState(() {
                                      _characters = value;
                                      deafultAgeGroup =
                                          EnumToString.convertToString(value);
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
                                  groupValue: _characters,
                                  onChanged: (value) {
                                    setState(() {
                                      _characters = value;
                                      deafultAgeGroup =
                                          EnumToString.convertToString(value);
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
                      ],
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Column(
                      children: [
                        Center(child: Text("Vaccine Dose")),
                        Divider(),
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
                                      deafultDose =
                                          EnumToString.convertToString(value);
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
                                      deafultDose =
                                          EnumToString.convertToString(value);
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
                      ],
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    DropdownSearch<String>(
                        mode: Mode.MENU,
                        showSelectedItem: true,
                        items: stateList,
                        label: "Select State",
                        hint: "country in menu mode",
                        popupItemDisabled: (String s) => s.startsWith('I'),
                        onChanged: (value) {
                          setState(() {
                            defaultState = value;
                            isDistLoaded = false;
                            getDist();
                          });
                        },
                        selectedItem: defaultState),
                    SizedBox(
                      height: 15,
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
                                    defaultDist = val;
                                  });
                                },
                                selectedItem: defaultDist,
                              )
                            : CircularProgressIndicator())
                        : SizedBox(
                            height: 20,
                          ),
                    SizedBox(
                      height: 20,
                    ),
                    Divider(),
                    Text("Select date range"),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextButton.icon(
                                onPressed: () {
                                  _selectDateStart(context);
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white10),
                                ),
                                icon: Icon(
                                  Icons.calendar_today,
                                  color: Colors.blueGrey[900],
                                ),
                                label: Text(
                                  "start date",
                                  style: TextStyle(color: Colors.blueGrey[900]),
                                )),
                            Text(DateFormat('dd-MM-yyyy')
                                .format(DateTime.parse(autoRunStartDate))),
                          ],
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextButton.icon(
                                onPressed: () {
                                  _selectDateEnd(context);
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white10),
                                ),
                                icon: Icon(
                                  Icons.calendar_today,
                                  color: Colors.blueGrey[900],
                                ),
                                label: Text("end date",
                                    style: TextStyle(
                                        color: Colors.blueGrey[900]))),
                            Text(DateFormat('dd-MM-yyyy')
                                .format(DateTime.parse(autoRunEndDate))),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Divider(),
                    Column(
                      children: [
                        Center(child: Text("pincode")),
                        Divider(),
                        Center(
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
                                  deafaultPincode = val;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 25,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  getDist() async {
    print("------ddist-----");
    districtList.clear();
    int tempStateID;
    widget.sCountry.states.forEach((element) {
      if (defaultState == element.stateName) {
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

  Future<void> _selectDateStart(BuildContext context) async {
    final DateTime pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.parse(autoRunStartDate),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 27)));
    if (pickedDate != null && pickedDate != selectedStartDate)
      setState(() {
        autoRunStartDate = pickedDate.toString();
      });
  }

  Future<void> _selectDateEnd(BuildContext context) async {
    final DateTime pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.parse(autoRunEndDate),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 27)));
    if (pickedDate != null && pickedDate != selectedEndDate)
      setState(() {
        autoRunEndDate = pickedDate.toString();
      });
  }

  saveToLocal() async {
    if (DateTime.parse(autoRunEndDate)
            .compareTo(DateTime.parse(autoRunStartDate)) >=
        0) {
      CookieManager tempCookie = CookieManager.getInstance();
      tempCookie.addToCookie('deafultSearchMode', deafultSearchMode);
      tempCookie.addToCookie('deafaultPincode', deafaultPincode);
      tempCookie.addToCookie('defaultState', defaultState);
      tempCookie.addToCookie('defaultDist', defaultDist);
      tempCookie.addToCookie('dafaultStateID', dafaultStateID);
      tempCookie.addToCookie('defaultDistID', defaultDistID);
      tempCookie.addToCookie('deafultAgeGroup', deafultAgeGroup);
      tempCookie.addToCookie('autoRunStartDate', autoRunStartDate);
      tempCookie.addToCookie('autoRunEndDate', autoRunEndDate);
      tempCookie.addToCookie('deafultDose', deafultDose);
      // tempCookie.addToCookie('aRReRunTimeInMin', aRReRunTimeInMin);
      // tempCookie.addToCookie('isAutoRunActive', isAutoRunActive);
      setState(() {
        isSaveStrart = false;
        Fluttertoast.showToast(msg: "Done!");
      });
      html.window.location.reload();
    } else {
      setState(() {
        isSaveStrart = false;
        Fluttertoast.showToast(
          msg: "start date should be less or equal the end date",
          timeInSecForIosWeb: 3,
        );
      });
    }
  }
}
