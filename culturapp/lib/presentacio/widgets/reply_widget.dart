import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:culturapp/translations/AppLocalizations';

class ReplyWidget extends StatefulWidget {
  final String foroId;
  final String? postId; 

  const ReplyWidget({
    required this.foroId,
    required this.postId, 
    required this.addReply,
    super.key});

  final FutureOr<void> Function(String foroId, String postId, String mensaje, String fecha, int numeroLikes) addReply;

  @override
  State<ReplyWidget> createState() => _ReplyWidgetState();
}

class _ReplyWidgetState extends State<ReplyWidget> {
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
                  hintText: 'send_reply'.tr(context),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'put_reply'.tr(context);
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