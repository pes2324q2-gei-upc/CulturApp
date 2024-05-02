import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ReportScreen extends StatefulWidget {
  final String  token;
  const ReportScreen({Key? key, required this.token}) : super(key: key);

  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _reportController = TextEditingController();

  Future<void> _sendReport(String token) async {

      final Map<String, dynamic> body = {
        'titol': _titleController.text,
        'report': _reportController.text,
      };

      try {
        final response = await http.post(
          Uri.parse('http://10.0.2.2:8080/tickets/reportBug/create'),
          headers: {
            'Content-Type': 'application/json', // Add this line
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(body)
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Reporte enviado correctamente' /*"correct_report_msg".tr(context)*/)),
          );
          _titleController.clear();
          _reportController.clear();

        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al enviar el reporte: ${response.body}' /*"error_report_msg".tr(context, {"error" : response.body})*/)),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al enviar el reporte' /*"error_report_msg".tr(context)*/)),
        );
      }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _reportController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF4692A),
        title: const Text('Reportar error en la aplicación' /*"report_bug_title".tr(context)*/),
        centerTitle: true, // Centrar el título
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
                controller: _reportController,
                maxLength: 1500,
                minLines: 1,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Error de la aplicación' /*"report_bug_description".tr(context)*/,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un error de la aplicación para reportarlo' /*"report_bug_description_missing".tr(context)*/;
                  }
                  return null;
                },
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
                      _sendReport(widget.token);
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
      home: const ReportScreen(token: "976f2f7b53c188d8a77b9b71887621d1e1d207faec5663bf79de9572ac887ea7"),
    );
  }
}
