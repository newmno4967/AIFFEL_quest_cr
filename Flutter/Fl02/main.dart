import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('플러터 앱 만들기',),
          centerTitle: true,
          backgroundColor: Colors.blue,
          leading: Icon(FontAwesomeIcons.heart),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: (){print('버튼이 눌렸습니다.');},
                child: Text('Text')
              ),
              Stack(
                children: [
                  Container(
                    color: Colors.blue,
                    width: 300,
                    height: 300,
                  ),
                  Container(
                    color: Colors.grey,
                    width: 240,
                    height: 240,
                  ),
                  Container(
                    color: Colors.pink,
                    width: 180,
                    height: 180,
                  ),
                  Container(
                    color: Colors.black,
                    width: 120,
                    height: 120,
                  ),
                  Container(
                    color: Colors.amber,
                    width: 60,
                    height: 60,
                  ),
                ],
              )
            ],
          )
        )
      )
    );
  }
}
