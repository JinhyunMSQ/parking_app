import 'package:flutter/material.dart';
import 'dart:async'; // Future 사용을 위해 추가

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
  int? _availableSpots; // Null when data is loading

  @override
  void initState() {
    super.initState();
    _fetchParkingData();
  }

  // 가상의 데이터를 반환하는 함수
  Future<void> _fetchParkingData() async {
    print("Fetching parking data...");
    await Future.delayed(const Duration(seconds: 2)); // 로딩 시뮬레이션
    setState(() {
      _availableSpots = 3;
      print("Parking data fetched: $_availableSpots spots available");
    });
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
          "주차장 자리가 종 $_availableSpots 자리 남아 있습니다.",
          style: const TextStyle(fontSize: 20),
        ), // 정상 데이터 표시
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _fetchParkingData, // 새로고침 버튼
        tooltip: 'Refresh',
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
