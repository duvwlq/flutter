import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class LabelChatScreen extends StatefulWidget {
  const LabelChatScreen({super.key});

  @override
  State<LabelChatScreen> createState() => _LabelChatScreenState();
}

class _LabelChatScreenState extends State<LabelChatScreen> {
  final List<Map<String, String>> _messages = [];

  Future<void> _pickAndSendImage() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    setState(() {
      _messages.add({'sender': 'me', 'text': '📸 사진을 업로드했습니다...'});
    });

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://10.0.2.2:8000/predict/'), // 에뮬레이터 환경에서는 10.0.2.2 사용
      );
      request.files.add(await http.MultipartFile.fromPath('file', image.path));

      var res = await request.send();
      final resBody = await res.stream.bytesToString();
      print('📢 Raw Server Response: $resBody'); // 디버깅용 출력

      if (res.statusCode == 200) {
        final data = jsonDecode(resBody);
        final results = data["results"] as List;

        final displayMessage = results.isNotEmpty
            ? results.map((item) =>
        "- ${item["label"]} (${item["confidence"]})"
        ).join('\n')
            : "🔍 인식된 라벨이 없습니다.";

        setState(() {
          _messages.add({'sender': 'bot', 'text': displayMessage});
        });
      } else {
        setState(() {
          _messages.add({'sender': 'bot', 'text': '❌ 서버 오류가 발생했습니다.'});
        });
      }
    } catch (e) {
      setState(() {
        _messages.add({'sender': 'bot', 'text': '❌ 오류 발생: ${e.toString()}'});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("세탁 라벨 챗봇")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isMe = msg['sender'] == 'me';
                return Container(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isMe ? Colors.blue[100] : Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(msg['text'] ?? ''),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton.icon(
              onPressed: _pickAndSendImage,
              icon: const Icon(Icons.image),
              label: const Text("사진 업로드"),
            ),
          )
        ],
      ),
    );
  }
}
