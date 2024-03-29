import 'dart:async';

import 'package:flutter/material.dart';

class Missatge extends StatefulWidget {
  const Missatge({
    required this.addPost, 
    //required this.foroId,
    Key? key}) : super(key: key);

  final FutureOr<void> Function(String foroId, String id, String username, String mensaje, DateTime fecha, int numeroLikes) addPost;

  @override
  State<Missatge> createState() => _MissatgeState();
}

class _MissatgeState extends State<Missatge> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_MissatgeState');
  final _controller = TextEditingController();

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
                  hintText: 'Publica un missatge',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Introdueix un missatge per continuar';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  //final String username = obtainUsername(); // Obtener el nombre de usuario de alguna manera
                  //final String foroId = widget.foroId; // Obtener el ID del foro de alguna manera
      
                  await widget.addPost(
                    'foroId', 
                    'id', //este param seguramente lo borre
                    'username', 
                    _controller.text, 
                    DateTime.now(), //cambiar por timeStamp
                    0, //número de likes en 0
                  );
                  _controller.clear();
                }
              },
              child: Row(
                children: const [
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