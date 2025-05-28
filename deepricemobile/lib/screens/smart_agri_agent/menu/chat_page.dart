
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../utils/utils.dart';
import '../../home/landing/service_component.dart';

class ChatPage extends StatefulWidget{
  const ChatPage({super.key});

  @override
  State<StatefulWidget> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    Map service = {
      'title': 'Smart Agri Chat',
      'link' : '/agri-chat',
      'illustration' : 'images/landing/services/agent.jpg',
      'shortDescription' : 'Get expert advice on rice farming with AI-powered insights. Ask anything and receive instant.'
    };
    ServiceInfo info = ServiceInfo(service['illustration'], service['shortDescription'], service['link'], service['title']);
    return Column(
          children: [
            // ServiceImageSection(info, isDetail: true,),
            ServiceDetailsSection(info, isDetail: true,),
            const SizedBox(height: 30,),
            // ServiceDetailsSection(info, isDetail: true,),
            // DiseaseImagePickerSection()
            ChatScreen()

          ],
        );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, String>> messages = []; // Stocke les messages
  String cleanMessage(String message) {
    return utf8.decode(message.runes.toList());
  }
  Future<void> sendMessage () async {
    if (_controller.text.isNotEmpty) {
      setState(() {
        messages.add({"role": "user", "text": _controller.text});
      });
      try {
        var baseUrl = DeepFarmUtils.baseUrl();
        final url = Uri.parse("$baseUrl/rag/query/");
        final response = await http.post(
          url,  // Remplace localhost par ton IP si nécessaire
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({"query": _controller.text}),
        );
        if (response.statusCode == 200) {
          // Décoder la réponse JSON
          final data = jsonDecode(response.body);
          String botResponse = data["user_response"];

          setState(() {
            // messages.removeLast(); // Supprime "Processing..."
            botResponse = cleanMessage(botResponse);
            messages.add({"role": "bot", "text": botResponse});
          });
        } else {
          setState(() {
            messages.removeLast();
            messages.add({"role": "bot", "text": "Error: Unable to get a response."});
          });
        }
      } catch (e) {
        setState(() {
          messages.removeLast();
          messages.add({"role": "bot", "text": "Error: Connection failed."});
        });
      }

      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          constraints: BoxConstraints(
            minHeight: 100, // Hauteur minimale
            maxHeight: 530, // Hauteur maximale pour éviter l'erreur
          ),
          child: ListView.builder(
            padding: EdgeInsets.all(10),
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final message = messages[index];
              bool isUser = message["role"] == "user";
              return Align(
                alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isUser ? Colors.blue[200] : Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(message["text"] ?? ""),
                ),
              );
            },
          ),
        ),
      Align(  // Garde la barre de saisie toujours en bas
        alignment: Alignment.bottomCenter,
        child:
        Padding(
          padding: EdgeInsets.all(8),
          child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Type a message...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: sendMessage,
                  color: Colors.blue,
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
