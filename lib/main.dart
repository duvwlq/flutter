import 'package:flutter/material.dart';
import 'label_chat_screen.dart';  // 챗봇 화면 파일 임포트

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '세탁 라벨 챗봇',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const StartScreen(),  // 시작화면 지정
      debugShowCheckedModeBanner: false,
    );
  }
}

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            textStyle: const TextStyle(fontSize: 18),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LabelChatScreen()),
            );
          },
          child: const Text("챗봇 시작하기"),
        ),
      ),
    );
  }
}
