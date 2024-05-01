import 'package:culturapp/domain/models/message.dart';
import 'package:culturapp/domain/models/usuari.dart';

class Grup {
  String id;
  String nomGroup;
  String imageGroup;
  String descripcio;
  String lastMessage;
  String timeLastMessage;
  List<Usuari>? participants;
  List<dynamic> membres;
  List<Message>? missatgesGrup;

  Grup({
    required this.id,
    required this.nomGroup,
    required this.imageGroup,
    required this.descripcio,
    required this.lastMessage,
    required this.timeLastMessage,
    required this.membres,
    this.participants,
    this.missatgesGrup,
  });

  factory Grup.fromJson(Map<String, dynamic> json) {
    return Grup(
        id: json['id'],
        nomGroup: json['nom'],
        imageGroup: json['imatge'],
        descripcio: json['descripcio'],
        lastMessage: json['last_msg'],
        timeLastMessage: json['last_time'],
        missatgesGrup: json['mensajes'],
        membres: json['participants']);
  }
}
