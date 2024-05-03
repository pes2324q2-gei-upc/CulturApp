import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:culturapp/presentacio/controlador_presentacio.dart';
import 'package:culturapp/translations/AppLocalizations';
import 'package:flutter/material.dart';

class PostWidget extends StatefulWidget {
  final String activitat;
  final ControladorPresentacion controladorPresentacion;

  const PostWidget({
    required this.controladorPresentacion,
    required this.activitat,
    required this.addPost,
    super.key});

  final FutureOr<void> Function(String foroId, String mensaje, String fecha, int numeroLikes) addPost;

  @override
  State<PostWidget> createState() => _PostWidgetState(controladorPresentacion);
}

class _PostWidgetState extends State<PostWidget> {
  late ControladorPresentacion _controladorPresentacion; 

   _PostWidgetState(ControladorPresentacion controladorPresentacion) {
    _controladorPresentacion = controladorPresentacion;
  }

  final _formKey = GlobalKey<FormState>(debugLabel: '_PostState');
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
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
                decoration: InputDecoration(
                  hintText: 'send_message'.tr(context),
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
                  String? foro = await _controladorPresentacion.getForoId(widget.activitat); 
                  if (foro != null) {
                    String data = Timestamp.now().toDate().toIso8601String();
                    await widget.addPost(
                      foro,
                      _controller.text,
                      data,
                      0, // número de likes en 0
                    );
                  }
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