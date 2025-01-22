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
          title: Text('플러터 앱 만들기',), // 문자 입력
          centerTitle: true, // 가운데 정렬
          backgroundColor: Colors.blue, // 타이틀 색
          leading: Icon(FontAwesomeIcons.heart), // 왼쪽위 아이콘 삽입
        ),
        body: Center( // 가운데정렬
          child: Column( // 세로로 2줄 사용
            mainAxisAlignment: MainAxisAlignment.center, // 가운데 정렬
            children: [
              ElevatedButton( // 버튼 만들기
                onPressed: (){print('버튼이 눌렸습니다.');},//버튼 클릭시 출력
                child: Text('Text') // 내용
              ),
              Stack( // 네모 그리기
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
// 스택 진행중 실험으로 크기를 0으로 주던가 삭제하면 전체 화면이 될줄알았는데 그경우 스텍이 기본 위치를 최상단 좌측을 디폴트값잡는 다는걸 배웠다
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

//김민상: 실제로 처음부터 만들어 보니 처음부터 생각할수 있는 시간이 되어 좋았다.
//최창윤: 그루님들의 도움을받아 드디어 스튜디어오 설정을 하고 화면공유 하게 되어 행복했고, 해당 코드를 짜는데 민상님과 이것저것 해보고 싶은걸 좋아해서 재밋었다. 다음 그루님 만날 때 여러가지 도전 해보고 싶다