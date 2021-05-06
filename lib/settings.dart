import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:vaccine_slot_finder/globalClass.dart';
import 'dart:ui';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  final Country sCountry;
  final SelcState sState;
  const Settings({this.sCountry, this.sState});

  @override
  _SettingsState createState() => _SettingsState();
}

enum searchBy { pincode, district }

class _SettingsState extends State<Settings> {
  List<String> stateList = [];
  List<String> districtList = [];
  searchBy _radio = searchBy.district;
  SelcState tempState;
  bool isStateLoaded = true;
  bool isDistLoaded = true;
  bool isSaveStrart = false;
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
    return Scaffold(
        backgroundColor: Colors.pink[50],
        appBar: AppBar(
          backgroundColor: Colors.purple[100],
          title: Text('about'),
        ),
        body: Container(
          child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
              DropdownSearch<String>(
                  mode: Mode.MENU,
                  showSelectedItem: true,
                  showSearchBox: true,
                  items: stateList,
                  label: "Select State",
                  hint: "country in menu mode",
                  popupItemDisabled: (String s) => s.startsWith('I'),
                  onChanged: (val) {
                    setState(() {
                      defaultState = val;
                      isDistLoaded = false;
                      getDist();
                    });
                  },
                  selectedItem: "Odisha"),
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
                          popupItemDisabled: (String s) => s.startsWith('I'),
                          onChanged: (val) {
                            setState(() {
                              defaultDist = val;
                            });
                          },
                          selectedItem: defaultDist,
                        )
                      : CircularProgressIndicator())
                  : SizedBox(
                      height: 15,
                    ),
              TextFormField(
                keyboardType: TextInputType.number,
                initialValue: deafaultPincode,
                onChanged: (val) {
                  setState(() {
                    deafaultPincode = val;
                  });
                },
              ),
              Divider(),
              SizedBox(
                height: 30,
              ),
              isSaveStrart
                  ? CircularProgressIndicator()
                  : ElevatedButton.icon(
                      onPressed: () {
                        tempState.districts.forEach((element) {
                          if (defaultDist == element.districtName) {
                            defaultDistID = element.districtId;
                          }
                        });
                        widget.sCountry.states.forEach((state) {
                          if (defaultState == state.stateName) {
                            defaultDistID = state.stateId;
                          }
                        });
                        setState(() {
                          isSaveStrart = true;
                          saveToLocal();
                        });
                      },
                      icon: Icon(
                        Icons.adb,
                        color: Colors.white54,
                      ),
                      label: Text(
                        "save changes",
                        style: TextStyle(color: Colors.white54),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.blueGrey[900]),
                      ),
                    ),
            ],
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

  saveToLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('defaultState', defaultState);
    await prefs.setString('defaultDist', defaultDist);
    await prefs.setString('deafaultPincode', deafaultPincode);
    await prefs.setString('deafultSearchMode', deafultSearchMode);
    await prefs.setInt('dafaultStateID', dafaultStateID);
    await prefs.setInt('defaultDistID', defaultDistID);

    setState(() {
      isSaveStrart = false;
      Fluttertoast.showToast(msg: "save successful");
    });
  }
}
