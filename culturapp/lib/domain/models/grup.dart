import 'package:culturapp/domain/models/message.dart';
import 'package:culturapp/domain/models/usuari.dart';

class Grup {
  //id grup
  String nomGroup;
  String imageGroup;
  String descripcio;
  String lastMessage;
  String timeLastMessage;
  List<Usuari> participants;
  List<Message> missatgesGrup;

  Grup({
    required this.nomGroup,
    required this.imageGroup,
    required this.descripcio,
    required this.lastMessage,
    required this.timeLastMessage,
    required this.participants,
    required this.missatgesGrup,
  });
}

List<Grup> allGroups = [
  Grup(
    nomGroup: 'Group1',
    imageGroup: 'assets/userImage.png',
    descripcio:
        'this is a grup for cool people :), the coolest around the sickest and the slayest',
    lastMessage: 'Hello everyone :D',
    timeLastMessage: '13:57',
    participants: allAmics,
    missatgesGrup: allMessage,
  ),
  Grup(
    nomGroup: 'Group2',
    imageGroup: 'assets/userImage.png',
    descripcio:
        'this is a grup for cool people :), the coolest around the sickest and the slayest',
    lastMessage: 'Does anybody knows?',
    timeLastMessage: '11:13',
    participants: allAmics,
    missatgesGrup: allMessage,
  ),
  Grup(
    nomGroup: 'Group3',
    imageGroup: 'assets/userImage.png',
    descripcio:
        'this is a grup for cool people :), the coolest around the sickest and the slayest',
    lastMessage: 'Thank you!',
    timeLastMessage: '01:13',
    participants: allAmics,
    missatgesGrup: allMessage,
  ),
  Grup(
    nomGroup: 'Group4',
    imageGroup: 'assets/userImage.png',
    descripcio:
        'this is a grup for cool people :), the coolest around the sickest and the slayest',
    lastMessage: 'Hbu?',
    timeLastMessage: '06:30',
    participants: allAmics,
    missatgesGrup: allMessage,
  ),
  Grup(
    nomGroup: 'Group5',
    imageGroup: 'assets/userImage.png',
    descripcio:
        'this is a grup for cool people :), the coolest around the sickest and the slayest',
    lastMessage: 'No',
    timeLastMessage: '16:30',
    participants: allAmics,
    missatgesGrup: allMessage,
  ),
  Grup(
    nomGroup: 'Avemaria',
    imageGroup: 'assets/userImage.png',
    descripcio:
        'this is a grup for cool people :), the coolest around the sickest and the slayest',
    lastMessage: 'Si',
    timeLastMessage: '16:30',
    participants: allAmics,
    missatgesGrup: allMessageDuo,
  ),
];
