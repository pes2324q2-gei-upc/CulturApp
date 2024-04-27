import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

//se puede reutilizar para el chat si añado un parametro que al llamarlo especifique si es el foro o el chat, para pasar unos atributos u otros
class ReplyWidget extends StatefulWidget {
  final String foroId;
  final String? postId; 

  const ReplyWidget({
    required this.foroId,
    required this.postId, 
    required this.addReply,
    super.key});

  final FutureOr<void> Function(String foroId, String postId, String username, String mensaje, String fecha, int numeroLikes) addReply;

  @override
  State<ReplyWidget> createState() => _ReplyWidgetState();
}

class _ReplyWidgetState extends State<ReplyWidget> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_PostState');
  final _controller = TextEditingController();
  late String _username;

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (snapshot.exists) {
        setState(() {
          _username = snapshot.data()?['username'] ?? '';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: _formKey,
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _controller,
                decoration: const InputDecoration(
                  hintText: 'Publica un resposta',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Introdueix una resposta per continuar';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final String foro = widget.foroId; 
                  String data = Timestamp.now().toDate().toIso8601String();
                  await widget.addReply(
                    foro,
                    widget.postId!, 
                    _username,
                    _controller.text,
                    data,
                    0, // número de likes en 0
                  );
                  _controller.clear();
                }
              },
              child: const Row(
                children: [
                  Icon(Icons.send),
                  SizedBox(width: 4),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}