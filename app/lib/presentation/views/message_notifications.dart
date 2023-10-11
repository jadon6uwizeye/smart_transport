import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Message {
  final String text;
  bool delivered; // Make delivered mutable

  Message(this.text, this.delivered);
}

class MessagingWidget extends StatefulWidget {
  @override
  _MessagingWidgetState createState() => _MessagingWidgetState();
}

class _MessagingWidgetState extends State<MessagingWidget> {
  final TextEditingController _messageController = TextEditingController();
  final List<Message> _messages = []; // Change the list type to List<Message>

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // add back button
      appBar: AppBar(
        title: Text('Message Notifications'),
        backgroundColor: Color.fromARGB(255, 4, 37, 99),
        // change the app bar height
        toolbarHeight: 70,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return ListTile(
                  title: Text(message.text),
                  subtitle: message.delivered
                      ? const Text(
                          'Delivered  ✔️ ✔️ ',
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            color: Colors.green,
                          ),
                        )
                      : const Text('Sending...',
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            color: Colors.grey,
                          )),
                  tileColor: Colors.grey[200],
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 16.0,
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.grey),
              ),
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type your message',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    handleMessageSubmit(_messageController.text);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void handleMessageSubmit(String message) async {
    final messageText = _messageController.text;
    if (messageText.isNotEmpty) {
      var jsonBody = {
        'phone_numbers': ['0789952243'],
        'message_content': _messageController.text
      };
      var resp = await http.post(
          Uri.parse('http://localhost:8001/location/send_custom_message/'),
          body: json.encode(jsonBody),
          headers: {
            // pass json as the content type
            "Content-Type": "application/json",
          });
      print(resp.body);
      setState(() {
        final newMessage = Message(messageText, true);
        _messages.add(newMessage);
        _messageController.clear();
        // Simulate a delay to show "Sending..." before marking as delivered
        Future.delayed(const Duration(seconds: 2), () {
          setState(() {
            newMessage.delivered = true;
          });
        });
      });
    }
  }
}
