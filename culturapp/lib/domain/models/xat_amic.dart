import 'package:culturapp/domain/models/message.dart';

class xatAmic {
  final String lastMessage;
  final String timeLastMessage;
  final String recieverId;
  final String senderId;
  final List<Message>? missatges;

  const xatAmic({
    required this.lastMessage,
    required this.timeLastMessage,
    required this.recieverId,
    required this.senderId,
    this.missatges,
  });

  factory xatAmic.fromJson(Map<String, dynamic> json) {
    return xatAmic(
        lastMessage: json['last_msg'],
        timeLastMessage: json['last_time'],
        recieverId: json['receiverId'],
        senderId: json['senderId'],
        missatges: json[
            'mensaje'] //!= null ? List<Message>.from(json['mensaje'].map((message) => Message.fromJson(message))) : null
        );
  }
}
