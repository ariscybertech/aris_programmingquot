import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(ProgrammingQuotes());
}

class ProgrammingQuotes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Programming Quotes',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  final apiUrl = 'https://programming-quotes-api.herokuapp.com/quotes/random';

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var response;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: (response == null)
                  ? AnimatedSwitcher(
                      duration: Duration(seconds: 1),
                      child: Text(
                        'Hey there!\nWant an awesome programming quote?',
                        style: TextStyle(
                            fontSize: 30.0,
                            fontFamily: 'FredokaOne',
                            color: Colors.grey[800]),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : Text(
                      response['en'],
                      style: TextStyle(
                          fontSize: 30.0,
                          fontFamily: 'FredokaOne',
                          color: Colors.grey[800]),
                      textAlign: TextAlign.center,
                    ),
            ),
            (response == null)
                ? Text('')
                : Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.only(right: 200.0, top: 10.0),
                      child: Text("-${response['author']}",
                          style: TextStyle(
                              fontSize: 15.0,
                              fontFamily: 'FredokaOne',
                              color: Colors.grey[800]),
                          textAlign: TextAlign.right),
                    ),
                  ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: RaisedButton(
                elevation: 0.0,
                hoverElevation: 0.0,
                focusElevation: 0.0,
                onPressed: () {
                  _pullRandomQuote();
                },
                child: Icon(Icons.navigate_next),
                color: Colors.grey[300],
                hoverColor: Colors.lightGreen,
                focusColor: Colors.lightGreen,
                splashColor: Colors.lightGreen,
              ),
            )
          ],
        ),
      ),
    ));
  }

  void _pullRandomQuote() {
    http.get(widget.apiUrl).then((value) {
      if (value.statusCode == 200) {
        var j = jsonDecode(value.body);
        if (j["en"] == null) {
          _pullRandomQuote();
        } else {
          setState(() {
            response = jsonDecode(value.body);
          });
        }
      }
    });
  }
}
