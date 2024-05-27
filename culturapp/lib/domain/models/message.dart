class Message {
  String text;
  String sender;
  String timeSended;

  Message({required this.text, required this.sender, required this.timeSended});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
        text: json['mensaje'],
        sender: json['senderId'],
        timeSended: json['fecha']);
  }
}
