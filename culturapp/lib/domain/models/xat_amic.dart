import 'package:culturapp/domain/models/message.dart';

class xatAmic {
  final String lastMssg;
  final String lastTime;
  final String recieverId;
  final String senderId;
  final List<Message> missatges;

  const xatAmic({
    required this.lastMssg,
    required this.lastTime,
    required this.recieverId,
    required this.senderId,
    required this.missatges,
  });
}

xatAmic xatMock = xatAmic(
  lastMssg: "hello",
  lastTime: "10:00",
  recieverId: "1",
  senderId: "2",
  missatges: missatgesAmic,
);
