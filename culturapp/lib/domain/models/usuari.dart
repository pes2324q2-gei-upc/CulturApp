class Usuari {
  final String id; //-> token
  final String nom;
  final String email;
  final String image;
  final List<String> activitats;
  final List<String> favCategories;
  final List<Usuari> followers; //aka amigos

  const Usuari({
    required this.id,
    required this.nom,
    required this.email,
    required this.image,
    required this.activitats,
    required this.favCategories,
    required this.followers,
  });
}

const List<Usuari> allAmics = [
  Usuari(
    id: '1',
    nom: 'Jaume',
    email: 'usuari@gmail.com',
    image: 'assets/userImage.png',
    activitats: ["a", "b"],
    favCategories: ["a", "b"],
    followers: [],
  ),
  Usuari(
    id: '2',
    nom: 'Oriol',
    email: 'usuari@gmail.com',
    image: 'assets/userImage.png',
    activitats: ["a", "b"],
    favCategories: ["a", "b"],
    followers: [],
  ),
  Usuari(
    id: '3',
    nom: 'Maira',
    email: 'usuari@gmail.com',
    image: 'assets/userImage.png',
    activitats: ["a", "b"],
    favCategories: ["a", "b"],
    followers: [],
  ),
  Usuari(
    id: '4',
    nom: 'Laia',
    email: 'usuari@gmail.com',
    image: 'assets/userImage.png',
    activitats: ["a", "b"],
    favCategories: ["a", "b"],
    followers: [],
  ),
  Usuari(
    id: '5',
    nom: 'Felip',
    email: 'usuari@gmail.com',
    image: 'assets/userImage.png',
    activitats: ["a", "b"],
    favCategories: ["a", "b"],
    followers: [],
  ),
  Usuari(
    id: '6',
    nom: 'Marc',
    email: 'usuari@gmail.com',
    image: 'assets/userImage.png',
    activitats: ["a", "b"],
    favCategories: ["a", "b"],
    followers: [],
  ),
];
