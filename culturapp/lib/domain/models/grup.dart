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
    imageGroup:
        'https://w7.pngwing.com/pngs/635/97/png-transparent-computer-icons-the-broadleaf-group-people-icon-miscellaneous-monochrome-black.png',
    lastMessage: 'Hello everyone :D',
    timeLastMessage: '13:57',
  ),
  Grup(
    titleGroup: 'Group2',
    imageGroup:
        'https://w7.pngwing.com/pngs/635/97/png-transparent-computer-icons-the-broadleaf-group-people-icon-miscellaneous-monochrome-black.png',
    lastMessage: 'Does anybody knows?',
    timeLastMessage: '11:13',
  ),
  Grup(
    titleGroup: 'Group3',
    imageGroup:
        'https://w7.pngwing.com/pngs/635/97/png-transparent-computer-icons-the-broadleaf-group-people-icon-miscellaneous-monochrome-black.png',
    lastMessage: 'Thank you!',
    timeLastMessage: '01:13',
  ),
  Grup(
    titleGroup: 'Group4',
    imageGroup:
        'https://w7.pngwing.com/pngs/635/97/png-transparent-computer-icons-the-broadleaf-group-people-icon-miscellaneous-monochrome-black.png',
    lastMessage: 'Hbu?',
    timeLastMessage: '06:30',
  ),
];
