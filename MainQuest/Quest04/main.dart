import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:camera/camera.dart';
import 'dart:io';

// 사진 데이터를 저장하는 클래스
class Photo {
  String path; // 사진 파일의 경로
  String title; // 사진의 제목

  Photo({required this.path, required this.title});
}

//메인 출력 함수
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras(); //사용 가능한 카메라 불러오기
  final firstCamera = cameras.first; // 첫 번째 카메라 선택

  runApp(MaterialApp(
    theme: ThemeData.dark(), // 다크 모드
    home: HomeScreen(camera: firstCamera), // 홈 화면
  ));
}

// 홈 화면 위젯
class HomeScreen extends StatefulWidget {
  final CameraDescription camera;

  const HomeScreen({Key? key, required this.camera}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Photo> photos = []; // 추가할 사진 리스트로 정의
  TextEditingController _urlController = TextEditingController(); // URL 입력 관리 컨트롤러
  late CameraController _controller; // 카메라 컨트롤러
  late Future<void> _initializeControllerFuture; // 카메라 초기화

  @override
  void initState() {
    super.initState();
    _controller = CameraController(widget.camera, ResolutionPreset.medium); // 카메라 설전
    _initializeControllerFuture = _controller.initialize(); // 카메라 초기화
  }

  // 사진 삭제 함수
  void removePhoto(Photo photo) {
    setState(() {
      photos.remove(photo);
    });
  }

  // 사진의 이름 업데이트 함수
  void updatePhotoTitle(Photo photo, String newTitle) {
    setState(() {
      photo.title = newTitle;
    });
  }

  // URL로 사진 추가
  void _addPhotoFromUrl() {
    final url = _urlController.text; // 사용자가 입력한 URL 저장
    if (url.isNotEmpty && Uri.tryParse(url)?.hasAbsolutePath == true) {
      setState(() {
        photos.add(Photo(path: url, title: '사진 분석 전')); // 리스트에 추가
      });
      _urlController.clear(); // 입력 필드 초기화
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('유효한 URL을 입력하세요')), // 잘못된 URL일시 출력
      );
    }
  }

  // 사진 분석 함수
  Future<String> identifyImage(String imagePath) async {
    final apiKey = 'AIzaSyANCUVFJuXuMKPzHkFXiUC1MZ2TFitFStc'; // 구글 비전 API 키
    final url = 'https://vision.googleapis.com/v1/images:annotate?key=$apiKey';

    // 네트워크 이미지인지 로컬 이미지인지 확인
    if (imagePath.startsWith('http')) {
      final response = await http.get(Uri.parse(imagePath)); // URL에서 이미지 다운
      if (response.statusCode == 200) {
        final base64Image = base64Encode(response.bodyBytes); // Base64로 변환

        final requestBody = {
          "requests": [
            {
              "image": {"content": base64Image}, // 분석할 이미지 데이터
              "features": [
                {"type": "LABEL_DETECTION", "maxResults": 5} //최대 5개의 라벨 감지 요청
              ]
            }
          ]
        };

        final visionResponse = await http.post(
          Uri.parse(url),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(requestBody),
        );

        if (visionResponse.statusCode == 200) {
          final result = jsonDecode(visionResponse.body);
          final labels = result['responses'][0]['labelAnnotations'];
          if (labels != null && labels.isNotEmpty) {
            return labels[0]['description']; // 가장 정확도 높은 라벨 반환
          } else {
            return '분류 결과 없음';
          }
        } else {
          print('Error: ${visionResponse.statusCode}');
          return '분류 실패';
        }
      } else {
        return '이미지를 불러올 수 없음';
      }
    } else {
      final imageBytes = File(imagePath).readAsBytesSync();
      final base64Image = base64Encode(imageBytes); // 로컬 파일을 Base64로 변환

      final requestBody = {
        "requests": [
          {
            "image": {"content": base64Image},
            "features": [
              {"type": "LABEL_DETECTION", "maxResults": 5}
            ]
          }
        ]
      };

      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        final labels = result['responses'][0]['labelAnnotations'];
        if (labels != null && labels.isNotEmpty) {
          return labels[0]['description'];
        } else {
          return '분류 결과 없음';
        }
      } else {
        print('Error: ${response.statusCode}');
        return '분류 실패';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('갤러리'),
      ),
      body: photos.isEmpty
          ? Center(child: Text("추가된 사진이 없습니다"))
          : GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // 한줄에 3개씩 보이게 출력
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        padding: EdgeInsets.all(8.0),
        itemCount: photos.length, // 모든 사진이 다 보이게
        itemBuilder: (context, index) {
          final photo = photos[index];
          return GestureDetector(
            onTap: () async {
              String label = await identifyImage(photo.path);
              updatePhotoTitle(photo, label); // 📌 분석 결과로 제목 변경
              Navigator.push( // 네비게이터를 사용하여 이미지 분석 화면으로 전환
                context,
                MaterialPageRoute(
                  builder: (context) => PhotoDetailPage(
                    photo: photo, // 사진
                    label: label, // 이름
                    onDelete: (photo) { // 삭제
                      setState(() {
                        photos.remove(photo);
                      });
                      Navigator.pop(context);
                    },
                  ),
                ),
              );
            },
            child: GridTile(
              child: photo.path.startsWith('http')
                  ? Image.network(photo.path, fit: BoxFit.cover) // URL 이미지
                  : Image.file(File(photo.path), fit: BoxFit.cover), //사진
              footer: GridTileBar(
                // 테두리를 적용시킨 사진 이름
                title: Stack(
                  children: [
                    Text(
                        photo.title,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          foreground: Paint()
                            ..style = PaintingStyle.stroke // 선(Stroke) 스타일 적용
                            ..strokeWidth = 3 // 테두리 두께
                            ..color = Colors.black, // 테두리 색상
                        )
                    ),
                    Text(
                      photo.title,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // 글자색
                      ),
                    ),
                  ],
                )
              ),
            ),
          );
        },
      ),
      //floatingActionButton으로 사진찍기
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera_alt), // 카메라 모양 아이콘 활용
        onPressed: () async {
          try {
            await _initializeControllerFuture;
            final image = await _controller.takePicture();
            setState(() {
              photos.add(Photo(path: image.path, title: '사진 분석 전')); // 리스트에 추가
            });
          } catch (e) {
            print(e); // 에러발생시 에러문구 출력
          }
        },
      ),
      // bottomNavigationBar로 URL 형식의 이미지를 입력받기
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _urlController, // URL 입력 필드
                  decoration: InputDecoration(
                    hintText: "이미지 URL 입력",
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.add_photo_alternate),
                onPressed: _addPhotoFromUrl,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PhotoDetailPage extends StatelessWidget {
  final Photo photo;
  final String label;
  final Function onDelete; // 삭제 함수 추가

  PhotoDetailPage({required this.photo, required this.label, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('사진 상세'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red), // 🗑 삭제 버튼
            onPressed: () {
              onDelete(photo); // 삭제 함수 실행
              Navigator.pop(context); // 현재 화면 닫기
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            photo.path.startsWith('http')
                ? Image.network(photo.path)
                : Image.file(File(photo.path)),
            SizedBox(height: 16.0),
            Text(
              '분석 결과: $label',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}