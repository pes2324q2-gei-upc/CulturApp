import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SolicitutScreen extends StatefulWidget {
  final String idActivitat;
  final String titolActivitat;
  final String token;
  SolicitutScreen({Key? key, required this.idActivitat, required this.titolActivitat, required this.token}) : super(key: key);

  @override
  _SolicitutScreenState createState() => _SolicitutScreenState();
}

class _SolicitutScreenState extends State<SolicitutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _motiuController = TextEditingController();

  Future<void> _sendmotiu(String token) async {

      final Map<String, dynamic> body = {
        'titol': _titleController.text,
        'idActivitat': widget.idActivitat,
        'motiu': _motiuController.text,
      };

      try {
        final response = await http.post(
          Uri.parse('http://10.0.2.2:8080/tickets/solicitudsOrganitzador/create'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(body)
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Solicitud enviado correctamente' /*"correct_aplicattion_msg".tr(context)*/)),
          );
          _titleController.clear();
          _motiuController.clear();

        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al enviar la solicitud: ${response.body}' /*"error_aplicattion_msg_parms".tr(context, {"error" : response.body})*/)),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al enviar la solicitud' /*"error_aplicattion_msg".tr(context)*/)),
        );
      }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _motiuController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF4692A),
        title: const Text("Solicitud de organizador" /*"aplicattion_title".tr(context)*/),
        centerTitle: true, 
        toolbarHeight: 50.0,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20.0,
          fontWeight: FontWeight.bold
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              const SizedBox(height: 5),
              TextFormField(
                initialValue: widget.titolActivitat,
                enabled: false,
                decoration: const InputDecoration(
                  labelText: "Titulo de la actividad" /*"aplicattion_title_activity".tr(context)*/,
                ),
              ),
              const SizedBox(height: 5),
              TextFormField(
                controller: _titleController,
                maxLength: 50,
                minLines: 1,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Asunto' /*"subject".tr(context)*/,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un asunto' /*"subject_missing".tr(context)*/;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 5),
              TextFormField(
                controller: _motiuController,
                maxLength: 1500,
                minLines: 1,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Motivo de la solicitud' /*"aplicattion_reason".tr(context)*/,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un motivo' /*"aplicattion_reason_missing".tr(context)*/;
                  }
                  return null;
                },
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
                      _sendmotiu(widget.token);
                    }
                  },
                  child: const Text('Enviar' /*"send".tr(context)*/),
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CulturApp',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SolicitutScreen(
        idActivitat: '20240102001',
        titolActivitat: 'titol Activitat',
        token: "976f2f7b53c188d8a77b9b71887621d1e1d207faec5663bf79de9572ac887ea7"
        ),
    );
  }
}
