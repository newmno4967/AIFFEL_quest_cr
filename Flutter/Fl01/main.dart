import 'dart:async';

void main() {
  Timer? timer;
  int seconds = 0; // 초를 저장할 변수 생성
  int minit = 0; // 분을 저장할 변수 생성
  int cycle = 1; // 몇번 반복됐는지 확인하는 변수 생성
  bool isWorkTime = true; // 작업 시간 여부를 판단

  void startPomodoroCycle() { // void를 만들어 실행
    print("🍅Pomodoro 타이머를 시작합니다🍅");
    print("====================================");
    print("타이머는 25분 작업과 5분 휴식으로 진행됩니다.");
    print('$cycle회차 시작');

    // timer?.cancel()를 입력하기 전까지 계속 1초마다 실행되는 코드
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if(seconds == 60){ // 초가 60이되면 분으로 바꿔주기
        seconds=0;
        minit++;
      }
      else {
        seconds++; // 초마다 1씩 추가
      }

      // 작업, 휴식 시간을 isWorkTime타입에따라 분류해 시각화하는 코드
      if (isWorkTime) {
        print("작업 시간: ${minit}m ${seconds}s");
      } else {
        print("휴식 시간: ${minit}m ${seconds}s");
      }

      // 작업/휴식 시간 완료 시
      if (isWorkTime && minit == 25) { //조건에 따라 작업시간 구분하기
        isWorkTime = false; //휴식시간으로 바꾸기
        seconds = 0; // 변수 초기화
        minit = 0; // 변수 초기화
        print("📌 작업 종료! 휴식 시작 📌");
      }
      // 조건에 따라(3항연산자 사용) 쉬는시간 재기
      else if (!isWorkTime && (cycle == 4 ? minit == 15 : minit == 5)) {
        cycle++; //cycle1바퀴 추가
        seconds = 0; // 변수 초기화
        minit = 0; // 변수 초기화
        isWorkTime = true; //작업시간으로 바꾸기

        if (cycle > 4) { // 4바퀴를돌면 종료하기
          print("🎉 모든 사이클 완료! 타이머를 종료합니다. 🎉");
          print("💪 수고하셨습니다! 💪");
          timer?.cancel();
        } else { // 4바퀴 미만일시 다시 실행
          print("⏳ 휴식 종료. $cycle회차 사이클 시작 ⏳");
          print("-" * 30);
        }
      }
    });
  }

  startPomodoroCycle();// 만들어둔 함수 실행
}