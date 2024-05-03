class Usuari {
  late String id; //-> token
  late String nom;
  late String email;
  late String image;
  late List<String> activitats;
  late List<dynamic> favCategories;
  late List<Usuari> followers; //aka amigos

  /*const Usuari({
    required this.id,
    required this.nom,
    required this.email,
    required this.image,
    required this.activitats,
    required this.favCategories,
    required this.followers,
  });*/
}
/*
const Usuari mockUsuari = Usuari(
  id: '1',
  nom: 'Jaume',
  email: 'usuari@gmail.com',
  image: 'assets/userImage.png',
  activitats: ["a", "b"],
  favCategories: ["a", "b"],
  followers: [],
);

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
];*/
