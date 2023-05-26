// ignore_for_file: no_leading_underscores_for_local_identifiers, unused_import, avoid_print
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gpt/chat_message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [];

  bool isTyping = false;

  bool isEmpty = true;

  bool chatHasError = false;

  final openAI = OpenAI.instance.build(
    token: "YOUR_API_KEY", 
    baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 5)),
    isLogger: true,
  );

  void _sendMessage() {
    ChatMessage _message =
        ChatMessage(text: _controller.text.trim(), sender: "You");

    setState(() {
      _messages.insert(0, _message);
      isTyping = true;
      chatHasError = false;
    });

    final request = CompleteText(
      prompt: _message.text,
      model: kTextDavinci3,
      maxTokens: 4000,
    );

    openAI.onCompletion(request: request).then((response) {
      ChatMessage _botMessage =
          ChatMessage(text: response!.choices[0].text, sender: "Bot");
      setState(() {
        _messages.insert(0, _botMessage);
        isTyping = false;
        chatHasError = false;
      });
      print(response);
    }).onError((error, stackTrace) {
      setState(() {
        chatHasError = true;
        isTyping = false;
      });
      print("$error");
    });
    _controller.clear();
  }

  Widget _buildTextComposer() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 5, top: 5),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: (value) {
                setState(() {
                  isEmpty = value.isNotEmpty;
                });
                if (RegExp(r'\s').matchAsPrefix(value) != null) {
                  setState(() {
                    isEmpty = false;
                  });
                }
              },
              autocorrect: true,
              controller: _controller,
              decoration: const InputDecoration.collapsed(
                hintText: "Type something .... ",
              ),
            ),
          ),
          IconButton(
            onPressed: isEmpty ? () => _sendMessage() : null,
            icon: const Icon(Icons.send),
          )
        ],
      ),
    );
  }

  showInfo() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Text("About"),
          content: Text("Credit to 'OpenAI' for all API used"),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 234, 239, 255),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        title: const Text(
          "ChatBOT",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () => showInfo(),
              child: const Icon(Icons.info_outline),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(bottom: 12),
          child: Column(
            children: [
              Flexible(
                child: NotificationListener<OverscrollIndicatorNotification>(
                  onNotification: (notification) {
                    notification.disallowIndicator();
                    return true;
                  },
                  child: ListView.builder(
                    reverse: true,
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: const EdgeInsets.only(
                            top: 10, bottom: 10, left: 0, right: 0),
                        child: _messages[index],
                      );
                    },
                  ),
                ),
              ),
              if (isTyping)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(color: Colors.black),
                  ),
                ),
              // return error message if chatbot has an error
              if (chatHasError == true)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(0),
                    child: Text(
                      "an error occurred",
                      style: TextStyle(color: Color.fromARGB(255, 245, 82, 70)),
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  padding: const EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: _buildTextComposer(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
