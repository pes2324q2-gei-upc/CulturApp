import 'package:culturapp/presentacio/controlador_presentacio.dart';
import 'package:culturapp/translations/AppLocalizations';
import 'package:flutter/material.dart';


class SolicitutScreen extends StatefulWidget {
  final String idActivitat;
  final String titolActivitat;
  final ControladorPresentacion controladorPresentacion;
  SolicitutScreen({super.key, required this.controladorPresentacion, required this.idActivitat, required this.titolActivitat});

  @override
  _SolicitutScreenState createState() => _SolicitutScreenState();
}

class _SolicitutScreenState extends State<SolicitutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _motiuController = TextEditingController();

  Future<void> _sendmotiu() async {

    int statusCode = await widget.controladorPresentacion.sendOrganizerApplication(_titleController.text, widget.idActivitat, _motiuController.text);  

    if (statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("correct_aplicattion_msg".tr(context)),
          backgroundColor: Colors.green,
        ),
        
      );
      _titleController.clear();
      _motiuController.clear();
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
        title: Text("aplicattion_title".tr(context)),
        centerTitle: true, 
        toolbarHeight: 50.0,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20.0,
        ),
        iconTheme: const IconThemeData(
          color: Colors.white, 
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                const SizedBox(height: 10),
                const Text(
                  'Por favor, tambien añada la siguiente información en la aplicación para solicitar ser organizador:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '- DNI\n- Teléfono\n- Correo\n- Empresa (si representa a alguna)',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
                const SizedBox(height: 5),
                TextFormField(
                  initialValue: widget.titolActivitat,
                  enabled: false,
                  decoration: InputDecoration(
                    labelText: "aplicattion_title_activity".tr(context),
                  ),
                ),
                const SizedBox(height: 5),
                TextFormField(
                  controller: _titleController,
                  maxLength: 50,
                  minLines: 1,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: "subject".tr(context),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty || value.trim().isEmpty) {
                      return "subject_missing".tr(context);
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
                  decoration: InputDecoration(
                    labelText: "aplicattion_reason".tr(context),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty || value.trim().isEmpty) {
                      return "aplicattion_reason_missing".tr(context);
                    }
                    return null;
                  },
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState != null && _formKey.currentState!.validate()) {
                        _sendmotiu();
                      }
                    },
                    child: Text("send".tr(context)),
                  ),
                ),
              ],
            ),
          ),
        ),
      )
    );
  }
}
