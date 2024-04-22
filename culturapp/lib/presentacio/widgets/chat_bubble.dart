import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String userName;
  final String message;
  final String time;

  const ChatBubble({
    super.key,
    required this.userName,
    required this.message,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    final isMe = userName == 'Me';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment:
                isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              if (!isMe) // If message is not from "Me"
                Text(
                  userName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              color: isMe ? Colors.orange : Colors.grey,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(isMe ? 8.0 : 0),
                topRight: Radius.circular(isMe ? 0 : 8.0),
                bottomLeft: const Radius.circular(8.0),
                bottomRight: const Radius.circular(8.0),
              ),
            ),
            padding: const EdgeInsets.all(8.0),
            margin: const EdgeInsets.symmetric(vertical: 4.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment:
                isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Text(
                time,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12.0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
