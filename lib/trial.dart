import 'package:flutter/material.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.all(15.0),
          children: <Widget>[
            Center(
              child: Container(
                padding: const EdgeInsets.all(8.0),
                color: Colors.black87,
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
                          "Signup",
                          style: TextStyle(color: Colors.white, fontSize: 30.0),
                          ),
                        ),
                      SizedBox(
                        height: 25,
                        ),

                      Card(
                        elevation: 6.0,
                        child: TextFormField(
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                            ),
                          decoration: InputDecoration(
                              prefixIcon: Padding(
                                padding: EdgeInsets.only(left: 20, right: 15),
                                child: Icon(Icons.person, color: Colors.black),
                                ),
                              contentPadding: EdgeInsets.all(18),
                              labelText: "Username"),
                          ),
                        ),

                      Card(
                        elevation: 6.0,
                        child: TextFormField(
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                            ),
                          decoration: InputDecoration(
                            labelText: "Password",
                            prefixIcon: Padding(
                              padding: EdgeInsets.only(left: 20, right: 15),
                              child: Icon(Icons.phonelink_lock,
                                              color: Colors.black),
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
                                      BorderRadius.circular(15.0)),
                                  child: Text(
                                    "Signup",
                                    style: TextStyle(fontSize: 18.0),
                                    ),
                                  textColor: Colors.white,
                                  color: Color(0xFFf7d426),
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/trial');
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
