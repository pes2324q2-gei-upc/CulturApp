
import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

Future<List> getUsuaris() async {
  List usuaris = [];
  CollectionReference crUsuaris = db.collection('Usuari');
  QuerySnapshot qeUsuaris = await crUsuaris.get();
  for (var doc in qeUsuaris.docs) {
    usuaris.add(doc.data());
  }
  return usuaris;
}

/* 
import 'package:culturapp/services/firebase_service.dart';

body:FutureBuilder( 
      future: getUsuaris(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data?.length ,
            itemBuilder: (context, index) {
              return Text(snapshot.data?[index]['nomusuari']);
           // return Text(snapshot.data?[index]['email']),
            },
          );
        } 
        else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      }
    ),*/