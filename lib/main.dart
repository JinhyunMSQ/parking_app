import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // HTTP 요청을 위한 패키지
import 'dart:convert'; // JSON 파싱을 위한 패키지

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Parking App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const ParkingHomePage(title: 'Parking Lot Status'),
    );
  }
}

class ParkingHomePage extends StatefulWidget {
  const ParkingHomePage({super.key, required this.title});

  final String title;

  @override
  State<ParkingHomePage> createState() => _ParkingHomePageState();
}

class _ParkingHomePageState extends State<ParkingHomePage> {
  int? _availableSpots; // 주차장 자리 수 저장 (로딩 중에는 null)
  final String _arduinoUrl = "http://192.168.0.13:8080"; // 아두이노 HTTP 서버 주소

  @override
  void initState() {
    super.initState();
    _fetchParkingData(); // 앱 시작 시 데이터 가져오기
  }

  // 아두이노에서 주차 데이터 가져오는 함수
  Future<void> _fetchParkingData() async {
    print("Sending request to $_arduinoUrl");
    try {
      final response = await http.get(Uri.parse(_arduinoUrl));
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body); // JSON 응답 파싱
        setState(() {
          _availableSpots = data['available_spots']; // 자리 수 업데이트
        });
      } else {
        // 서버 오류 처리
        setState(() {
          _availableSpots = -1; // 오류 상태
        });
        print("Error: Server responded with status ${response.statusCode}");
      }
    } catch (e) {
      // 네트워크 오류 처리
      setState(() {
        _availableSpots = -1; // 오류 상태
      });
      print("Error fetching data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: _availableSpots == null
            ? const CircularProgressIndicator() // 데이터 로딩 중
            : _availableSpots == -1
                ? const Text(
                    "데이터를 가져오는 중 오류가 발생했습니다.",
                    style: TextStyle(fontSize: 18),
                  ) // 오류 메시지
                : Text(
                    "주차장 자리가 총 $_availableSpots 자리 남아 있습니다.",
                    style: const TextStyle(fontSize: 20),
                  ), // 정상 데이터 표시
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print("Refresh button pressed");
          _fetchParkingData(); // 새로고침
        },
        tooltip: 'Refresh',
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
