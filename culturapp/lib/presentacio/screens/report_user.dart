import 'package:culturapp/presentacio/controlador_presentacio.dart';
import 'package:culturapp/translations/AppLocalizations';
import 'package:flutter/material.dart';

class ReportUserScreen extends StatefulWidget {
  final String userReported;
  final ControladorPresentacion controladorPresentacion;
  const ReportUserScreen({super.key,  required this.userReported, required this.controladorPresentacion,});

  @override
  _ReportUserScreenState createState() => _ReportUserScreenState();
}

class _ReportUserScreenState extends State<ReportUserScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _reportController = TextEditingController();

  Future<void> _sendReport() async {
    int statusCode = await widget.controladorPresentacion.sendReportUser(
      _titleController.text,
      widget.userReported,
      _reportController.text,
    );

    if (statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
         content: Text("correct_report_msg".tr(context)),
         backgroundColor: Colors.green,),
      );
      _titleController.clear();
      _reportController.clear();
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
        title: Text("report_bug_title".tr(context)),
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
                controller: _reportController,
                maxLength: 1500,
                minLines: 1,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: "report_bug_description".tr(context),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty || value.trim().isEmpty) {
                    return "report_bug_description_missing".tr(context);
                  }
                  return null;
                },
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
                      _sendReport();
                    }
                  },
                  child: Text("send".tr(context)),
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}

