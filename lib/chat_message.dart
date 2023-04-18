import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  final String text;
  final String sender;
  const ChatMessage({super.key, required this.text, required this.sender});

  Widget named(BuildContext cont) {
    if (sender == "Bot") {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(left: 10),
            margin: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundColor: Colors.black,
              child: Text(
                sender[0],
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sender,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  child: Text(
                    text.trim(),
                    style: const TextStyle(color: Colors.black, fontSize: 16),
                  ),
                )
              ],
            ),
          ),
          Container(padding: const EdgeInsets.only(left: 10))
        ],
      );
    }

    // else
    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(left: 10),
            margin: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundColor: Colors.indigo,
              child: Text(
                sender[0],
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sender,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  child: Text(
                    text,
                    style: const TextStyle(color: Colors.black, fontSize: 16),
                  ),
                )
              ],
            ),
          ),
          Container(padding: const EdgeInsets.only(left: 10))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return named(context);
  }
}
