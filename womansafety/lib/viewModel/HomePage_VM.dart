// @dart=2.9
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:telephony/telephony.dart';
import 'package:woman_safety/Utilities.dart';
import 'package:woman_safety/model/User.dart';
import 'package:woman_safety/view/HomePage.dart';

class HomePage_VM {
  final Telephony telephony = Telephony.instance;

  getLocation() async {
    var permission = await Permission.location.isGranted;
    if (permission) {
      Position res = await Geolocator.getCurrentPosition();
      String link =
          "https://maps.google.com/?q=${res.latitude},${res.longitude}";
      // print(link);
      sendSms(link);
    }
  }

  phonecall() async {
    var url = HomePageState.recipents[0];
    var call = await Permission.phone.request();
    var sms = await Permission.sms.request();
    if (sms.isGranted) {}
    if (call.isGranted) {
      var a =
          await FlutterPhoneDirectCaller.callNumber(url['phone'].toString());
    }
  }

  sendSms(String link) async {
    var numbers = "";
    HomePageState.recipents.forEach((element) {
      numbers = "$numbers ${element['name']} :  ${element['phone']}\n";
    });
    String message =
        "Emergency message from ${HomePageState.username}. I need help immediately. This is where i am now: $link ";
    // print(link);
    bool permissionsGranted = await telephony.requestPhoneAndSmsPermissions;
    HomePageState.recipents.forEach((element) {
      telephony.sendSms(to: element['phone'].toString(), message: message);
      message =
          "${HomePageState.place}.\n ${HomePageState.address}.\n  Gurdians :$numbers ";
      telephony.sendSms(to: element['phone'].toString(), message: message);
    });
    phonecall();
  }
}

class Gurdian_VM {
  getGurdian() async {
    GuardianState.guardians = [];
    var li = await OurDatabase(table: Gurdians().table).getTables() as List;
    li.forEach((element) {
      GuardianState.guardians.add(getSingle(element as Map<String, dynamic>));
      (GuardianState.contextt as StatefulElement).state.setState(() {});
    });
  }

  Widget getSingle(Map<String, dynamic> mp) {
    Widget wi = Card(
        child: Container(
            padding: EdgeInsets.all(10),
            height: 120,
            child: Column(children: [
              Row(children: [
                Container(
                    alignment: Alignment.topLeft,
                    child: Text(mp['name'], style: TextStyle(fontSize: 18))),
                Spacer(),
                IconButton(
                    onPressed: (() {
                      updateAlert(mp);
                    }),
                    icon: Icon(Icons.edit_rounded))
              ]),
              Row(children: [
                Container(
                    alignment: Alignment.topLeft,
                    child: Text(mp['phone'].toString(),
                        style: TextStyle(fontSize: 18))),
                Spacer(),
                mp['name'] != "Police"
                    ? IconButton(
                        onPressed: (() {
                          removeAlert(mp);
                        }),
                        icon: Icon(Icons.delete_forever_rounded))
                    : Container()
              ])
            ])));
    return wi;
  }

  removeAlert(Map<String, dynamic> mp) {
    var context = GuardianState.contextt;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 100.0),
              child: AlertDialog(
                  title: Text('Remove guardian'),
                  content: Text('Are you sure ?'),
                  actions: [
                    IconButton(
                        onPressed: (() {
                          Navigator.pop(context);
                        }),
                        icon: Icon(Icons.close_rounded)),
                    IconButton(
                        onPressed: (() {
                          remove(mp);
                          Navigator.pop(context);
                        }),
                        icon: Icon(Icons.done_rounded))
                  ]));
        });
  }

  remove(Map<String, dynamic> mp) async {
    var a = await OurDatabase(table: Gurdians().table).delete('id', [mp['id']]);
    print(a);
    getGurdian();
  }

  updateAlert(Map<String, dynamic> mp) {
    TextEditingController name = TextEditingController();
    TextEditingController phone = TextEditingController();
    name.text = mp['name'];
    phone.text = mp['phone'].toString();

    var context = GuardianState.contextt;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 100.0),
              child: AlertDialog(
                  title: Center(
                      child: (Column(children: [
                    TextFormField(
                        controller: name,
                        keyboardType: TextInputType.name,
                        enabled: mp['name'] == "Police" ? false : true),
                    TextFormField(
                      controller: phone,
                      keyboardType: TextInputType.number,
                      maxLength: 10,
                    )
                  ]))),
                  actions: [
                    IconButton(
                        onPressed: (() {
                          Navigator.pop(context);
                        }),
                        icon: Icon(Icons.close_rounded)),
                    IconButton(
                        onPressed: (() {
                          bool status = false;
                          if (name.text != "") {
                            if (phone.text != "") {
                              if (phone.text.length == 10) {
                                update({
                                  "id": mp['id'],
                                  "name": "${name.text}",
                                  "phone": "${phone.text}"
                                });
                                status = true;
                              } else
                                status = false;
                            } else
                              status = false;
                          } else
                            status = false;

                          if (!status) {
                            var snackBar =
                                SnackBar(content: Text('Input Corrrect data'));
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          } else
                            getGurdian();
                          Navigator.pop(context);
                          HomePageState().getGurdians();
                        }),
                        icon: Icon(Icons.done_rounded))
                  ]));
        });
  }

  update(Map<String, dynamic> mp) async {
    await OurDatabase(table: Gurdians().table).updateTable(mp);
  }

  gurdianAlert() {
    TextEditingController name = TextEditingController();
    TextEditingController phone = TextEditingController();

    var context = GuardianState.contextt;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 100.0),
              child: AlertDialog(
                  title: Center(
                      child: (Column(children: [
                    TextFormField(
                        controller: name,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(labelText: 'Name')),
                    TextFormField(
                        controller: phone,
                        keyboardType: TextInputType.number,
                        maxLength: 10,
                        decoration: InputDecoration(labelText: 'Number'))
                  ]))),
                  actions: [
                    IconButton(
                        onPressed: (() {
                          Navigator.pop(context);
                        }),
                        icon: Icon(Icons.close_rounded)),
                    IconButton(
                        onPressed: (() {
                          bool status = false;
                          if (name.text != "") {
                            if (phone.text != "") {
                              if (phone.text.length == 10) {
                                status = true;
                                addGurdian(name.text, phone.text);
                              } else
                                status = false;
                            } else
                              status = false;
                          } else
                            status = false;

                          if (!status) {
                            var snackBar =
                                SnackBar(content: Text('Input Corrrect data'));
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          } else
                            getGurdian();
                          HomePageState().getGurdians();
                          Navigator.pop(context);
                        }),
                        icon: Icon(Icons.done_rounded))
                  ]));
        });
    getGurdian();
  }

  addGurdian(String name, String phone) {
    var data = {"id": Random().nextInt(100), "name": name, "phone": phone};
    Gurdians().connectDatabase(data);
  }
}

class Profile_VM {
  getUser() async {
    GuardianState.guardians = [];
    var li = await OurDatabase(table: User().table).getTables() as List;
    updateAlert(li.first as Map<String, dynamic>);
  }

  updateAlert(Map<String, dynamic> mp) {
    TextEditingController name = TextEditingController();
    TextEditingController phone = TextEditingController();
    TextEditingController address = TextEditingController();
    TextEditingController place = TextEditingController();

    name.text = mp['name'];
    phone.text = mp['password'].toString();
    address.text = mp['address'];
    place.text = mp['place'];

    var context = HomePageState.contextt;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 500),
              child: AlertDialog(
                  title: Center(
                      child: (Column(children: [
                    TextFormField(
                      controller: name,
                      keyboardType: TextInputType.name,
                    ),
                    TextFormField(
                      controller: phone,
                      keyboardType: TextInputType.number,
                      maxLength: 10,
                    ),
                    TextFormField(
                      controller: place,
                      keyboardType: TextInputType.number,
                    ),
                    TextFormField(
                      controller: address,
                      keyboardType: TextInputType.number,
                    )
                  ]))),
                  actions: [
                    IconButton(
                        onPressed: (() {
                          Navigator.pop(context);
                        }),
                        icon: Icon(Icons.close_rounded)),
                    IconButton(
                        onPressed: (() {
                          bool status = false;
                          if (name.text != "") {
                            if (phone.text != "") {
                              if (phone.text.length == 10) {
                                if (place.text != "") {
                                  if (address.text != "") {
                                    update({
                                      "id": mp['id'],
                                      "name": "${name.text}",
                                      "password": "${phone.text}",
                                      "place": "${place.text}",
                                      "address": "${address.text}"
                                    });
                                    status = true;
                                  } else
                                    status = false;
                                } else
                                  status = false;
                              } else
                                status = false;
                            } else
                              status = false;
                          } else
                            status = false;

                          if (!status) {
                            var snackBar =
                                SnackBar(content: Text('Input Corrrect data'));
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          } else
                            Navigator.pop(context);
                        }),
                        icon: Icon(Icons.done_rounded))
                  ]));
        });
  }

  update(Map<String, dynamic> mp) async {
    await OurDatabase(table: User().table).updateTable(mp);
  }
}
