import 'package:culturapp/domain/xat_amic.dart';

class Usuari {
  //id seria lo seu??
  final String nom;
  final String image;
  final String lastMessage;
  final String timeLastMessage;
  final xatAmic xat;
  //o també podrien anar a xatAmic, suposo que tindri amés sentit???

  const Usuari({
    required this.nom,
    required this.image,
    required this.lastMessage,
    required this.timeLastMessage,
    required this.xat,
  });
}

Usuari usuariMock = Usuari(
  nom: 'usuariMock',
  image: 'assets/userImage.png',
  lastMessage: 'hey',
  timeLastMessage: '10:00',
  xat: xatMock,
);

List<Usuari> allAmics = [
  Usuari(
    nom: 'Jaume',
    image: 'assets/userImage.png',
    lastMessage: 'Hello :D',
    timeLastMessage: '13:57',
    xat: xatMock,
  ),
  Usuari(
    nom: 'Oriol',
    image: 'assets/userImage.png',
    lastMessage: 'Hello :D',
    timeLastMessage: '13:57',
    xat: xatMock,
  ),
  Usuari(
    nom: 'Maira',
    image: 'assets/userImage.png',
    lastMessage: 'Hello :D',
    timeLastMessage: '13:57',
    xat: xatMock,
  ),
  Usuari(
    nom: 'Laia',
    image: 'assets/userImage.png',
    lastMessage: 'Hello :D',
    timeLastMessage: '13:57',
    xat: xatMock,
  ),
  Usuari(
    nom: 'Felip',
    image: 'assets/userImage.png',
    lastMessage: 'Hello :D',
    timeLastMessage: '13:57',
    xat: xatMock,
  ),
  Usuari(
    nom: 'Marc',
    image: 'assets/userImage.png',
    lastMessage: 'Hello :D',
    timeLastMessage: '13:57',
    xat: xatMock,
  ),
];
