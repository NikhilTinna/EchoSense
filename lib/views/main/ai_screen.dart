import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AIScreen extends StatelessWidget {
  const AIScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AI Screen'),
      ),
      body: CaptionGenerator(), // Add the CaptionGenerator widget here
    );
  }
}

class CaptionGenerator extends StatefulWidget {
  @override
  _CaptionGeneratorState createState() => _CaptionGeneratorState();
}

class _CaptionGeneratorState extends State<CaptionGenerator> {
  TextEditingController _promptController = TextEditingController();
  List<String> _captions = [];
  List<String> _chatMessages = [];

  Future<void> _generateCaptions() async {
    String prompt = _promptController.text;
    var response = await http.post(
      Uri.parse(
          'http://192.168.73.110:5000/generate_captions'), // Update URL as needed
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'prompt': prompt}),
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      Future.delayed(Duration(seconds: 2), () {
        setState(() {
          _captions = List<String>.from(data['captions']);
          _chatMessages.add(prompt); // Add user input to chat messages
          _chatMessages
              .addAll(_captions); // Add generated captions to chat messages
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: _chatMessages.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(_chatMessages[index]),
              );
            },
          ),
        ),
        TextField(
          controller: _promptController,
          decoration: InputDecoration(labelText: 'Enter a prompt'),
        ),
        SizedBox(height: 20.0),
        ElevatedButton(
          onPressed: _generateCaptions,
          child: Text('Generate Captions'),
        ),
      ],
    );
  }
}
