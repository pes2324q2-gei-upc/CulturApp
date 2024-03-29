import 'dart:async';

import 'package:flutter/material.dart';

class Foro extends StatefulWidget {
  const Foro({required this.addMessage, super.key});

  final FutureOr<void> Function(String message) addMessage;

  @override
  State<Foro> createState() => _ForoState();
}

class _ForoState extends State<Foro> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_ForoState');
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
                  await widget.addMessage(_controller.text);
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