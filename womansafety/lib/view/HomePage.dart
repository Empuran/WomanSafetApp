// @dart=2.9
import 'dart:io' show Platform;
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shake/shake.dart';
import 'package:woman_safety/Utilities.dart';
import 'package:woman_safety/model/User.dart';
import 'package:woman_safety/viewModel/HomePage_VM.dart';

class Register extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RegistertState();
  }
}

class RegistertState extends State<Register> {
  TextEditingController name_c, phone_c, address_c, place_c;
  static BuildContext contextt;
  @override
  void initState() {
    name_c = TextEditingController();
    phone_c = TextEditingController();
    address_c = TextEditingController();
    place_c = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    contextt = context;
    return Scaffold(
        appBar: AppBar(title: Text("Women Safety")),
        body: SingleChildScrollView(
            child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(10),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Fill your basic details",
                        style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Colors.black54,
                            fontSize: 20.0),
                      ),
                      SizedBox(height: 20.0),
                      Container(
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: TextField(
                              keyboardType: TextInputType.name,
                              controller: name_c,
                              decoration: InputDecoration(
                                  hintText: "Enter your Name",
                                  border: UnderlineInputBorder(),
                                  labelText: 'Name',
                                  labelStyle: TextStyle(color: Colors.blue),
                                  alignLabelWithHint: true))),
                      SizedBox(height: 10.0),
                      Container(
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: TextField(
                              controller: phone_c,
                              keyboardType: TextInputType.phone,
                              onChanged: (value) {},
                              decoration: InputDecoration(
                                  hintText: "Enter your Phone",
                                  border: UnderlineInputBorder(),
                                  labelText: 'Phone',
                                  labelStyle: TextStyle(color: Colors.blue),
                                  alignLabelWithHint: true))),
                      SizedBox(height: 10.0),
                      Container(
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: TextField(
                              controller: place_c,
                              keyboardType: TextInputType.name,
                              onChanged: (value) {},
                              decoration: InputDecoration(
                                  hintText: "Enter your Place",
                                  border: UnderlineInputBorder(),
                                  labelText: 'Place',
                                  labelStyle: TextStyle(color: Colors.blue),
                                  alignLabelWithHint: true))),
                      SizedBox(height: 10.0),
                      Container(
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: TextField(
                              controller: address_c,
                              keyboardType: TextInputType.streetAddress,
                              onChanged: (value) {},
                              maxLines: 3,
                              decoration: InputDecoration(
                                  hintText: "Enter your Address",
                                  border: UnderlineInputBorder(),
                                  labelText: 'Address',
                                  labelStyle: TextStyle(color: Colors.blue),
                                  alignLabelWithHint: true))),
                      SizedBox(height: 10.0),
                      SizedBox(height: 25.0),
                      Material(
                          elevation: 5,
                          color: Colors.lightBlue,
                          borderRadius: BorderRadius.circular(32.0),
                          child: MaterialButton(
                              onPressed: () async {
                                await Permission.location.request();
                                await Permission.phone.request();
                                await Permission.sms.request();
                                saveData();
                              },
                              minWidth: 200.0,
                              height: 45.0,
                              child: Text("Register",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20.0))))
                    ]))));
  }

  saveData() {
    if (name_c.text == "") {
      var snackBar = SnackBar(content: Text(' invailed Name'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if (phone_c.text == "" ||
        phone_c.text.length < 10 ||
        phone_c.text.length > 10) {
      var snackBar = SnackBar(content: Text('invailed Phone'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if (address_c.text == "") {
      var snackBar = SnackBar(content: Text(' invailed Address'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if (place_c.text == "") {
      var snackBar = SnackBar(content: Text(' invailed Place'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      var data = {
        "id": Random().nextInt(100),
        "name": name_c.text,
        "password": phone_c.text,
        "address": address_c.text,
        "place": place_c.text
      };
      HomePageState.visibility = true;
      CreatContactState.user = data;
      Navigator.pushReplacement(contextt,
          MaterialPageRoute(builder: (BuildContext context) => CreatContact()));
    }
  }
}

class CreatContact extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CreatContactState();
  }
}

class CreatContactState extends State<CreatContact> {
  static Map<String, dynamic> user;
  TextEditingController g1name, g1number, g2name, g2number;
  String g1nameError, g1numError, g2nameError, g2numError;

  @override
  void initState() {
    g1name = TextEditingController();
    g1number = TextEditingController();
    g2name = TextEditingController();
    g2number = TextEditingController();
    g2name.text = "Police";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Women Safety")),
        backgroundColor: Colors.pink[100],
        body: SingleChildScrollView(
            child: Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.all(10),
                child: Column(children: [
                  Text(
                    "Add you guardians details",
                    style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Colors.black54,
                        fontSize: 20.0),
                  ),
                  Column(children: [
                    Card(
                        child: Column(children: [
                      SizedBox(height: 10.0),
                      Container(
                          alignment: Alignment.topLeft,
                          child: Row(children: [
                            Text("  Guardian", style: TextStyle(fontSize: 16)),
                            Spacer(),
                          ])),
                      Container(
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: TextField(
                              controller: g1name,
                              keyboardType: TextInputType.name,
                              onChanged: (value) {},
                              decoration: InputDecoration(
                                  border: UnderlineInputBorder(),
                                  labelText: 'Name',
                                  labelStyle: TextStyle(color: Colors.blue),
                                  errorText: g1nameError,
                                  alignLabelWithHint: true))),
                      SizedBox(height: 10.0),
                      Container(
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: TextField(
                              controller: g1number,
                              keyboardType: TextInputType.phone,
                              maxLength: 10,
                              onChanged: (value) {},
                              decoration: InputDecoration(
                                  border: UnderlineInputBorder(),
                                  labelText: 'Phone',
                                  labelStyle: TextStyle(color: Colors.blue),
                                  errorText: g1numError,
                                  alignLabelWithHint: true))),
                      SizedBox(height: 20.0)
                    ])),
                    Card(
                        child: Column(children: [
                      SizedBox(height: 10.0),
                      Container(
                          alignment: Alignment.topLeft,
                          child: Row(children: [
                            Text("  Police", style: TextStyle(fontSize: 16)),
                            Spacer(),
                          ])),
                      Container(
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: TextField(
                              controller: g2name,
                              enabled: false,
                              keyboardType: TextInputType.name,
                              onChanged: (value) {},
                              decoration: InputDecoration(
                                  border: UnderlineInputBorder(),
                                  labelText: 'Name',
                                  labelStyle: TextStyle(color: Colors.blue),
                                  errorText: g2nameError,
                                  alignLabelWithHint: true))),
                      SizedBox(height: 10.0),
                      Container(
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: TextField(
                              controller: g2number,
                              keyboardType: TextInputType.phone,
                              onChanged: (value) {},
                              maxLength: 10,
                              decoration: InputDecoration(
                                  border: UnderlineInputBorder(),
                                  labelText: 'Phone',
                                  labelStyle: TextStyle(color: Colors.blue),
                                  errorText: g2numError,
                                  alignLabelWithHint: true))),
                      SizedBox(height: 20.0)
                    ]))
                  ])
                ]))),
        bottomNavigationBar: Container(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: FlatButton(
                onPressed: (() {
                  addGurdian();
                }),
                color: Colors.blue,
                child: Text("Add"))));
  }

  addGurdian() {
    var snackBar = SnackBar(content: Text(''));

    if (checkG1()) {
      if (checkG2()) {
        snackBar = SnackBar(content: Text('Added'));
        saveData();
      } else {
        snackBar = SnackBar(
            content: Text('Police contact  is null! please enter details'));
      }
    } else
      snackBar = SnackBar(
          content: Text('Gurdian contact is null! please enter details'));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  saveData() {
    var g1 = {
      "id": Random().nextInt(100),
      "name": "${g1name.text}",
      "phone": "${g1number.text}"
    };
    var g2 = {
      "id": Random().nextInt(100),
      "name": "${g2name.text}",
      "phone": "${g2number.text}"
    };

    User().connectDatabase(user);
    List<Map<String, dynamic>> list = [g1, g2];
    list.forEach((element) {
      Gurdians().connectDatabase(element);
    });
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => MyHomePage()));
  }

  bool checkG1() {
    if (g1name.text.isNotEmpty) {
      setState(() {
        g1nameError = null;
      });
      if (g1number.text.isNotEmpty) {
        if (g1number.text.length == 10) {
          setState(() {
            g1numError = null;
          });
          if (user['password'] != g1number.text) {
            return true;
          } else {
            setState(() {
              g1numError = "User number and Gurdian number can't be same";
            });
            return false;
          }
        } else {
          setState(() {
            g1numError = "enter number";
          });
          return false;
        }
      } else {
        setState(() {
          g1numError = "enter number";
        });
        return false;
      }
    } else {
      setState(() {
        g1nameError = "enter name";
      });
      return false;
    }
  }

  bool checkG2() {
    if (g2name.text.isNotEmpty) {
      setState(() {
        g2nameError = null;
      });
      if (g2number.text.isNotEmpty) {
        setState(() {
          g2numError = null;
        });
        if (g2number.text.length == 10) {
          setState(() {
            g2numError = null;
          });
          if (user['password'] != g2number.text) {
            setState(() {
              g2numError = null;
            });
            if (user['password'] != g1number.text) {
              setState(() {
                g2numError = null;
              });
              return true;
            } else {
              setState(() {
                g2numError = "Gurdians number can't be same";
              });
              return false;
            }
          } else {
            setState(() {
              g2numError = "User number and Gurdian number can't be same";
            });
            return false;
          }
        }
      } else {
        setState(() {
          g2numError = "enter number";
          return false;
        });
      }
    } else {
      setState(() {
        g2nameError = "enter name";
      });
      return false;
    }
    return false;
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<MyHomePage> {
  static const platform = const MethodChannel('com.example.woman_safety/sense');
  var id;
  static BuildContext contextt;
  ShakeDetector detector;
  Position res;
  static List<Map<String, dynamic>> recipents = [];
  static String username, place, address = "";
  bool backgroundState = false;
  static var visibility = false;
  @override
  void initState() {
    getUser();
    getGurdians();
    detector = ShakeDetector.waitForStart(
        shakeSlopTimeMS: 1000,
        onPhoneShake: () {
          if (!backgroundState) {
            show(detector.mShakeCount);
          }
        });
    detector.startListening();
  }

  @override
  Widget build(BuildContext context) {
    contextt = context;

    return Scaffold(
        appBar: AppBar(title: Text("Women Safety ")),
        body: SingleChildScrollView(
            child: Center(
                child: Stack(alignment: Alignment.center, children: [
          Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            GestureDetector(
              child: Lottie.asset("assets/alert.json"),
              onTap: (() {
                HomePage_VM().getLocation();
              }),
              onLongPress: (() {
                var snackBar = SnackBar(content: Text('Alert Buton'));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }),
            ),
            Text('Press the bell button to send alert',
                style: TextStyle(
                    color: Colors.black45, fontStyle: FontStyle.italic)),
            SizedBox(height: 50),
            Visibility(
                visible: Platform.isAndroid ? true : false,
                child: Column(children: [
                  Switch(
                      value: backgroundState,
                      onChanged: ((state) {
                        setState(() {
                          backgroundSense(state);
                        });
                      })),
                  SizedBox(height: 20),
                  Text('Turn on|off background mode ',
                      style: TextStyle(
                          color: Colors.black45, fontStyle: FontStyle.italic))
                ]))
          ]),
          Visibility(
              visible: visibility,
              child: Card(
                  color: Colors.transparent,
                  child: Container(
                      padding: EdgeInsets.only(left: 5, right: 5),
                      height: 300,
                      width: 200,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Spacer(),
                            Image.asset("assets/shake.png"),
                            Text("Shake 3 times to send alert message",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24)),
                            Spacer(),
                            RaisedButton.icon(
                                onPressed: (() {
                                  skip();
                                }),
                                icon: Icon(Icons.done),
                                label: Text("Got It"))
                          ]))))
        ]))),
        drawer: drawer);
  }

  skip() async {
    setState(() {
      visibility = false;
    });
  }

  getUser() async {
    var li = await OurDatabase(table: User().table).getTables() as List;
    var mp = li.first as Map<String, dynamic>;
    print(mp);
    setState(() {
      username = mp['name'];
      place = mp['place'];
      address = mp['address'];
      id = mp['id'];
      if (mp['background'] == 1) {
        backgroundSense(true);
      }
    });
  }

  getGurdians() async {
    recipents = [];
    var list = await OurDatabase(table: Gurdians().table).getTables() as List;
    list.forEach((element) {
      var mp = element as Map<String, dynamic>;
      recipents.add(mp);
      setState(() {});
    });
  }

  Widget drawer = Drawer(
      child: ListView(padding: EdgeInsets.zero, children: <Widget>[
    DrawerHeader(
        child:
            Center(child: Text('Woman Safety', style: TextStyle(fontSize: 22))),
        decoration: BoxDecoration(color: Colors.blue)),
    ListTile(
        title: Text('Profile'),
        trailing: Icon(Icons.edit),
        onTap: () {
          Navigator.pop(contextt);
          Profile_VM().getUser();
        }),
    ListTile(
        title: Text('Gurdians & Police'),
        trailing: Icon(Icons.arrow_forward),
        onTap: () {
          Navigator.push(
              contextt, MaterialPageRoute(builder: (context) => Guardian()));
        }),
    ListTile(
        title: Text('About'),
        trailing: Icon(Icons.arrow_forward),
        onTap: () {
          Navigator.push(
              contextt, MaterialPageRoute(builder: (context) => About()));
        }),
  ]));

  show(var value) {
    var snackBar = SnackBar(content: Text('Alert senting..'));
    print(value);
    if (value == 3) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      HomePage_VM().getLocation();
    }
  }

  backgroundSense(bool state) async {
    String data = "";
    String response = "";
    if (state) {
      backgroundState = state;
      try {
        recipents.forEach((element) {
          data = "$data ${element['name']} : ${element['phone']} ,";
        });
        final String result = await platform.invokeMethod('start', {
          'name': HomePageState.username +
              "/" +
              HomePageState.place +
              "/" +
              HomePageState.address,
          'data': data
        });
        response = result;
        //   var snackBar = SnackBar(content: Text('Background sense  activated'));
        // ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } on PlatformException catch (e) {
        response = "Failed to Invoke: '${e.message}'.";
      }
    } else {
      backgroundState = state;
      try {
        final String result = await platform.invokeMethod('stop');
        response = result;
        //  var snackBar = SnackBar(content: Text('Background sense  deactivated'));
        //  ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } on PlatformException catch (e) {
        response = "Failed to Invoke: '${e.message}'.";
      }
    }
    setState(() {});
    print(response);
    await OurDatabase(
      table: User().table,
    ).updateTable({'id': id, 'background': state});
  }
}

class Guardian extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return GuardianState();
  }
}

class GuardianState extends State<Guardian> {
  static BuildContext contextt;
  static List<Widget> guardians = [];
  @override
  void initState() {
    Gurdian_VM().getGurdian();
  }

  @override
  Widget build(BuildContext context) {
    contextt = context;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text('Guardians')),
      backgroundColor: Colors.pink[50],
      body: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: guardians)),
      floatingActionButton: FloatingActionButton(
          onPressed: (() {
            Gurdian_VM().gurdianAlert();
          }),
          child: Icon(Icons.add_rounded)),
    );
  }
}

class About extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AboutState();
  }
}

class AboutState extends State<About> {
  static BuildContext contextt;
  static List<Widget> guardians = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('About')),
      backgroundColor: Colors.pink[50],
      body: Center(
          child: Container(
        padding: EdgeInsets.all(20),
        alignment: Alignment.center,
        child: Text(
            "This is a mobile app which the women can handle like a friend .it help them in a unsafe situation",
            style: TextStyle(
                color: Colors.grey[900],
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic)),
      )),
    );
  }
}
