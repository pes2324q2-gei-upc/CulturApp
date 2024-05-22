import 'package:firebase_messaging/firebase_messaging.dart';

class MessageArguments {
  final RemoteMessage message;
  final bool fromNotification;

  MessageArguments(this.message, this.fromNotification);
}
