class Usuari {
  final String nom;
  final String image;
  final String lastMessage;
  final String timeLastMessage;

  const Usuari({
    required this.nom,
    required this.image,
    required this.lastMessage,
    required this.timeLastMessage,
  });
}

const List<Usuari> allAmics = [
  Usuari(
    nom: 'Jaume',
    image: 'assets/userImage.png',
    lastMessage: 'Hello :D',
    timeLastMessage: '13:57',
  ),
  Usuari(
    nom: 'Oriol',
    image: 'assets/userImage.png',
    lastMessage: 'Hello :D',
    timeLastMessage: '13:57',
  ),
  Usuari(
    nom: 'Maira',
    image: 'assets/userImage.png',
    lastMessage: 'Hello :D',
    timeLastMessage: '13:57',
  ),
  Usuari(
    nom: 'Laia',
    image: 'assets/userImage.png',
    lastMessage: 'Hello :D',
    timeLastMessage: '13:57',
  ),
  Usuari(
    nom: 'Felip',
    image: 'assets/userImage.png',
    lastMessage: 'Hello :D',
    timeLastMessage: '13:57',
  ),
  Usuari(
    nom: 'Marc',
    image: 'assets/userImage.png',
    lastMessage: 'Hello :D',
    timeLastMessage: '13:57',
  ),
];
