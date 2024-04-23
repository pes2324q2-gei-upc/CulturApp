class Grup {
  final String titleGroup;
  final String imageGroup;
  //de moment url pero després maybe cambiar??
  final String lastMessage;
  final String timeLastMessage;

  const Grup({
    required this.titleGroup,
    required this.imageGroup,
    required this.lastMessage,
    required this.timeLastMessage,
  });
}

const List<Grup> allGroups = [
  Grup(
    titleGroup: 'Group1',
    imageGroup: 'assets/userImage.png',
    lastMessage: 'Hello everyone :D',
    timeLastMessage: '13:57',
  ),
  Grup(
    titleGroup: 'Group2',
    imageGroup: 'assets/userImage.png',
    lastMessage: 'Does anybody knows?',
    timeLastMessage: '11:13',
  ),
  Grup(
    titleGroup: 'Group3',
    imageGroup: 'assets/userImage.png',
    lastMessage: 'Thank you!',
    timeLastMessage: '01:13',
  ),
  Grup(
    titleGroup: 'Group4',
    imageGroup: 'assets/userImage.png',
    lastMessage: 'Hbu?',
    timeLastMessage: '06:30',
  ),
  Grup(
    titleGroup: 'Group5',
    imageGroup: 'assets/userImage.png',
    lastMessage: 'No',
    timeLastMessage: '16:30',
  ),
  Grup(
    titleGroup: 'Avemaria',
    imageGroup: 'assets/userImage.png',
    lastMessage: 'Si',
    timeLastMessage: '16:30',
  ),
];
