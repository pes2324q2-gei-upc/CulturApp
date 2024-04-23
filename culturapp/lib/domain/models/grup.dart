import 'package:culturapp/domain/models/usuari.dart';

class Grup {
  final String titleGroup;
  final String imageGroup;
  final String lastMessage;
  final String timeLastMessage;
  final List<Usuari> participants;

  const Grup({
    required this.titleGroup,
    required this.imageGroup,
    required this.lastMessage,
    required this.timeLastMessage,
    required this.participants,
  });
}

const List<Grup> allGroups = [
  Grup(
    titleGroup: 'Group1',
    imageGroup: 'assets/userImage.png',
    lastMessage: 'Hello everyone :D',
    timeLastMessage: '13:57',
    participants: allAmics,
  ),
  Grup(
    titleGroup: 'Group2',
    imageGroup: 'assets/userImage.png',
    lastMessage: 'Does anybody knows?',
    timeLastMessage: '11:13',
    participants: allAmics,
  ),
  Grup(
    titleGroup: 'Group3',
    imageGroup: 'assets/userImage.png',
    lastMessage: 'Thank you!',
    timeLastMessage: '01:13',
    participants: allAmics,
  ),
  Grup(
    titleGroup: 'Group4',
    imageGroup: 'assets/userImage.png',
    lastMessage: 'Hbu?',
    timeLastMessage: '06:30',
    participants: allAmics,
  ),
  Grup(
    titleGroup: 'Group5',
    imageGroup: 'assets/userImage.png',
    lastMessage: 'No',
    timeLastMessage: '16:30',
    participants: allAmics,
  ),
  Grup(
    titleGroup: 'Avemaria',
    imageGroup: 'assets/userImage.png',
    lastMessage: 'Si',
    timeLastMessage: '16:30',
    participants: allAmics,
  ),
];
