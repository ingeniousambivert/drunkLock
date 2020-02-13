import 'package:flutter/material.dart';
import 'driver_input.dart';
import 'contact_input.dart';


void main() => runApp(new DrunkLock());

class DrunkLock extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: ThemeData(),
      //darkTheme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      // Initial route set to home screen.
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/driverInput': (context) => DriverImageInput(),
        '/contactInput': (context) => ContactImageInput(),
      },
      );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.all(15.0),
          children: <Widget>[
            Center(
              child: Container(
                padding: const EdgeInsets.all(8.0),
                color: Colors.white,
                child: Form(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset('assets/images/logo.png'),
                      SizedBox(
                        height: 40,
                        ),
                      SizedBox(
                        height: 50,
                        child: Text(
                          "Sign Up",
                          style: TextStyle(color: Colors.black87, fontSize: 30.0),
                          ),
                        ),
                      SizedBox(
                        height: 25,
                        ),

                      Card(
                        color: Colors.grey[900],
                        elevation: 3.0,
                        child: TextFormField(
                          style: TextStyle(
                            color: Colors.white60,
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                            ),
                          decoration: InputDecoration(
                              prefixIcon: Padding(
                                padding: EdgeInsets.only(left: 20, right: 15),
                                child: Icon(Icons.person, color: Colors.white),
                                ),
                              contentPadding: EdgeInsets.all(18),
                              labelText: "Email", labelStyle: TextStyle(
                            color: Colors.white60,

                            ),),
                          ),
                        ),

                      Card(
                        elevation: 3.0,
                        color: Colors.grey[900],
                        child: TextFormField(
                          style: TextStyle(
                            color: Colors.white60,
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                            ),
                          decoration: InputDecoration(
                            labelText: "Password",
                            labelStyle: TextStyle(
                                color: Colors.white60,
                                ),
                            prefixIcon: Padding(
                              padding: EdgeInsets.only(left: 20, right: 15),
                              child: Icon(Icons.phonelink_lock,
                                              color: Colors.white),
                              ),
                            contentPadding: EdgeInsets.all(18),
                            ),
                          ),
                        ),

                      SizedBox(
                        height: 12,
                        ),

                      Padding(
                        padding: EdgeInsets.all(14.0),
                        ),

                      new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          SizedBox(
                              height: 44.0,
                              child: RaisedButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(10.0)),
                                  child: Text(
                                    "Signup",
                                    style: TextStyle(fontSize: 15.0),
                                    ),
                                  textColor: Colors.white,
                                  color: Colors.pinkAccent[700],
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/driverInput');
                                  })),
                        ],
                        ),
                    ],
                    ),
                  ),
                ),
              ),
          ],
          ),
        ),
      );
  }
}
