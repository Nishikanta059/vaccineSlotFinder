import 'dart:html';

import 'package:enum_to_string/enum_to_string.dart';

enum minAge { age18to45, ageAbove45 }

String deafultSearchMode = 'district';
String deafultAgeGroup = EnumToString.convertToString(minAge.age18to45);
String deafaultPincode = '744101';
String defaultState = 'Odisha';
String defaultDist = 'Khurda';
String dafaultStateID = '26';
String defaultDistID = '512';
String autoRunStartDate;
String autoRunEndDate;
String autoRunDays;
String isAutoRunActive = 'no';
String aRReRunTimeInMin = '10';

class Country {
  List<States> states;
  int ttl;

  Country({this.states, this.ttl});

  Country.fromJson(Map<String, dynamic> json) {
    if (json['states'] != null) {
      // ignore: deprecated_member_use
      states = new List<States>();
      json['states'].forEach((v) {
        states.add(new States.fromJson(v));
      });
    }
    ttl = json['ttl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.states != null) {
      data['states'] = this.states.map((v) => v.toJson()).toList();
    }
    data['ttl'] = this.ttl;
    return data;
  }
}

class States {
  int stateId;
  String stateName;

  States({this.stateId, this.stateName});

  States.fromJson(Map<String, dynamic> json) {
    stateId = json['state_id'];
    stateName = json['state_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['state_id'] = this.stateId;
    data['state_name'] = this.stateName;
    return data;
  }
}

class SelcState {
  List<Districts> districts;
  int ttl;

  SelcState({this.districts, this.ttl});

  SelcState.fromJson(Map<String, dynamic> json) {
    if (json['districts'] != null) {
      districts = new List<Districts>();
      json['districts'].forEach((v) {
        districts.add(new Districts.fromJson(v));
      });
    }
    ttl = json['ttl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.districts != null) {
      data['districts'] = this.districts.map((v) => v.toJson()).toList();
    }
    data['ttl'] = this.ttl;
    return data;
  }
}

class Districts {
  int districtId;
  String districtName;

  Districts({this.districtId, this.districtName});

  Districts.fromJson(Map<String, dynamic> json) {
    districtId = json['district_id'];
    districtName = json['district_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['district_id'] = this.districtId;
    data['district_name'] = this.districtName;
    return data;
  }
}

class DistCenters {
  List<Centers> centers;

  DistCenters({this.centers});

  DistCenters.fromJson(Map<String, dynamic> json) {
    if (json['centers'] != null) {
      centers = new List<Centers>();
      json['centers'].forEach((v) {
        centers.add(new Centers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.centers != null) {
      data['centers'] = this.centers.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Centers {
  int centerId;
  String name;
  String address;
  String stateName;
  String districtName;
  String blockName;
  int pincode;
  int lat;
  int long;
  String from;
  String to;
  String feeType;
  List<Sessions> sessions;

  Centers(
      {this.centerId,
      this.name,
      this.address,
      this.stateName,
      this.districtName,
      this.blockName,
      this.pincode,
      this.lat,
      this.long,
      this.from,
      this.to,
      this.feeType,
      this.sessions});

  Centers.fromJson(Map<String, dynamic> json) {
    centerId = json['center_id'];
    name = json['name'];
    address = json['address'];
    stateName = json['state_name'];
    districtName = json['district_name'];
    blockName = json['block_name'];
    pincode = json['pincode'];
    lat = json['lat'];
    long = json['long'];
    from = json['from'];
    to = json['to'];
    feeType = json['fee_type'];
    if (json['sessions'] != null) {
      sessions = new List<Sessions>();
      json['sessions'].forEach((v) {
        sessions.add(new Sessions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['center_id'] = this.centerId;
    data['name'] = this.name;
    data['address'] = this.address;
    data['state_name'] = this.stateName;
    data['district_name'] = this.districtName;
    data['block_name'] = this.blockName;
    data['pincode'] = this.pincode;
    data['lat'] = this.lat;
    data['long'] = this.long;
    data['from'] = this.from;
    data['to'] = this.to;
    data['fee_type'] = this.feeType;
    if (this.sessions != null) {
      data['sessions'] = this.sessions.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Sessions {
  String sessionId;
  String date;
  int availableCapacity;
  int minAgeLimit;
  String vaccine;
  List<String> slots;

  Sessions(
      {this.sessionId,
      this.date,
      this.availableCapacity,
      this.minAgeLimit,
      this.vaccine,
      this.slots});

  Sessions.fromJson(Map<String, dynamic> json) {
    sessionId = json['session_id'];
    date = json['date'];
    availableCapacity = json['available_capacity'];
    minAgeLimit = json['min_age_limit'];
    vaccine = json['vaccine'];
    slots = json['slots'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['session_id'] = this.sessionId;
    data['date'] = this.date;
    data['available_capacity'] = this.availableCapacity;
    data['min_age_limit'] = this.minAgeLimit;
    data['vaccine'] = this.vaccine;
    data['slots'] = this.slots;
    return data;
  }
}

class CookieManager {
  static CookieManager _manager;

  static getInstance() {
    if (_manager == null) {
      _manager = CookieManager();
    }
    return _manager;
  }

  void addToCookie(String key, String value) {
    // 2592000 sec = 30 days.
    document.cookie = "$key=$value; max-age=2592000; path=/;";
  }

  String getCookie(String key) {
    String cookies = document.cookie;
    List<String> listValues = cookies.isNotEmpty ? cookies.split(";") : List();
    String matchVal = "";
    for (int i = 0; i < listValues.length; i++) {
      List<String> map = listValues[i].split("=");
      String _key = map[0].trim();
      String _val = map[1].trim();
      if (key == _key) {
        matchVal = _val;
        break;
      }
    }
    return matchVal;
  }
}
