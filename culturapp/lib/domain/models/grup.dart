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
      membres: json['participants']
    );
  }
}

List<Grup> allGroups = [
  Grup(
    id: '1',
    nomGroup: 'Group1',
    imageGroup: 'assets/userImage.png',
    descripcio:
        'this is a grup for cool people :), the coolest around the sickest and the slayest',
    lastMessage: 'Hello everyone :D',
    timeLastMessage: '13:57',
    participants: allAmics,
    membres: ['1', '2'],
    missatgesGrup: allMessage,
  ),
  Grup(
    id: '2',
    nomGroup: 'Group2',
    imageGroup: 'assets/userImage.png',
    descripcio:
        'this is a grup for cool people :), the coolest around the sickest and the slayest',
    lastMessage: 'Does anybody knows?',
    timeLastMessage: '11:13',
    participants: allAmics,
    membres: ['1', '2'],
    missatgesGrup: allMessage,
  ),
  Grup(
    id: '3',
    nomGroup: 'Group3',
    imageGroup: 'assets/userImage.png',
    descripcio:
        'this is a grup for cool people :), the coolest around the sickest and the slayest',
    lastMessage: 'Thank you!',
    timeLastMessage: '01:13',
    participants: allAmics,
    membres: ['1', '2'],
    missatgesGrup: allMessage,
  ),
  Grup(
    id: '4',
    nomGroup: 'Group4',
    imageGroup: 'assets/userImage.png',
    descripcio:
        'this is a grup for cool people :), the coolest around the sickest and the slayest',
    lastMessage: 'Hbu?',
    timeLastMessage: '06:30',
    participants: allAmics,
    membres: ['1', '2'],
    missatgesGrup: allMessage,
  ),
  Grup(
    id: '5',
    nomGroup: 'Group5',
    imageGroup: 'assets/userImage.png',
    descripcio:
        'this is a grup for cool people :), the coolest around the sickest and the slayest',
    lastMessage: 'No',
    timeLastMessage: '16:30',
    participants: allAmics,
    membres: ['1', '2'],
    missatgesGrup: allMessage,
  ),
  Grup(
    id: '6',
    nomGroup: 'Avemaria',
    imageGroup: 'assets/userImage.png',
    descripcio:
        'this is a grup for cool people :), the coolest around the sickest and the slayest',
    lastMessage: 'Si',
    timeLastMessage: '16:30',
    participants: allAmics,
    membres: ['1', '2'],
    missatgesGrup: allMessageDuo,
  ),
];
