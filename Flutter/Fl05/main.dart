import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MainScreen()
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _JellyfishScreenState createState() => _JellyfishScreenState();
}

class _JellyfishScreenState extends State<MainScreen>{
  String result = "";

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Jellyfish"),
        centerTitle: true, // 타이틀을 중앙으로 정렬
        backgroundColor: Colors.blue, // AppBar 색상
        leading: Image.asset('images/jellyfish.jpg'), // 왼쪽 상단 아이콘
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Image.asset(
                'images/jellyfish.jpg',
                width: 300,
                height: 300,
              )
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    try {
                      final enteredUrl = 'https://2f64-180-70-132-82.ngrok-free.app/'; // 입력된 URL 가져오기
                      final response = await http.get(
                        Uri.parse(enteredUrl + "sample"), // 입력된 URL 사용
                        headers: {
                          'Content-Type': 'application/json',
                          'ngrok-skip-browser-warning': '69420',
                        },
                      );
                      if (response.statusCode == 200) {
                        final data = jsonDecode(response.body);
                        setState(() {
                          result =
                          "predicted_label: ${data['predicted_label']}";
                        });
                      } else {
                        setState(() {
                          result = "Failed to fetch data. Status Code: ${response.statusCode}";
                        });
                      }
                      debugPrint(result);
                    } catch (e) {
                      setState(() {
                        result = "Error: $e";
                      });
                    } // 클릭 시 DEBUG 콘솔 출력
                  },
                  child: Text(
                    "predicted",
                    style: TextStyle(fontSize: 30),
                  ),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      final enteredUrl = 'https://2f64-180-70-132-82.ngrok-free.app/'; // 입력된 URL 가져오기
                      final response = await http.get(
                        Uri.parse(enteredUrl + "sample"), // 입력된 URL 사용
                        headers: {
                          'Content-Type': 'application/json',
                          'ngrok-skip-browser-warning': '69420',
                        },
                      );
                      if (response.statusCode == 200) {
                        final data = jsonDecode(response.body);
                        setState(() {
                          result =
                          "prediction_score: ${data['prediction_score']}";
                        });
                      } else {
                        setState(() {
                          result = "Failed to fetch data. Status Code: ${response.statusCode}";
                        });
                      }
                      debugPrint(result);
                    } catch (e) {
                      setState(() {
                        result = "Error: $e";
                      });
                    } // 클릭 시 DEBUG 콘솔 출력
                  },
                  child: Text(
                    "prediction",
                    style: TextStyle(fontSize: 30),
                  ),
                )
              ],
            ) // 버튼 텍스트
          ],
        ),
      ),
    );
  }
}