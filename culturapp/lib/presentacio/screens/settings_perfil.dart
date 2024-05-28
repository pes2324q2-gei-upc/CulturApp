import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:culturapp/presentacio/controlador_presentacio.dart';

import '../../translations/AppLocalizations'; // Importa tu clase de localización

class SettingsPerfil extends StatefulWidget {
  final ControladorPresentacion controladorPresentacion;

  const SettingsPerfil({Key? key, required this.controladorPresentacion}) : super(key: key);

  @override
  State<SettingsPerfil> createState() => _SettingsPerfil(this.controladorPresentacion);
}

class _SettingsPerfil extends State<SettingsPerfil> {
  late ControladorPresentacion _controladorPresentacion;
  bool privat = false;
  final User? _user = FirebaseAuth.instance.currentUser;

  _SettingsPerfil(ControladorPresentacion controladorPresentacion) {
    _controladorPresentacion = controladorPresentacion;
  }

  @override
  void initState(){
    super.initState();
    checkPrivacy(_user!.uid);
  } 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF4692A),
        title: Text(
          'settings'.tr(context),
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(
          color: Colors.white, // Cambia el color de la flecha de retroceso
        ),
      ),
      body: Column(
        children: [
          SwitchListTile(
            title: Text("privacy".tr(context)),
            subtitle: Text("privacy_explanation".tr(context)),
            value: privat,
            activeColor: Color(0xFFF4692A),
            onChanged: (bool value) {
              setState(() {
                privat = value;
                _controladorPresentacion.changePrivacy(_user!.uid, privat);
              });
            },
            secondary: const Icon(Icons.lock),
          ),
          const Divider(height: 0),
          ListTile(
            title: const Text('Language'),
            subtitle: Text(_controladorPresentacion.language!.languageCode),
            leading: const Icon(Icons.language),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              _showLanguageSelector(context);
            },
          ),
          const Divider(height: 0),
          ListTile(
            title: Text('logout'.tr(context)),
            leading: const Icon(Icons.exit_to_app),
            onTap: () {
              _signOut(context);
            },
          ),
          const Divider(height: 0),
          ListTile(
            title: Text('delete_account'.tr(context)),
            subtitle: Text("delete_account_permanently".tr(context)),
            leading: const Icon(Icons.delete),
            onTap: () {
              // Delete account logic
            },
          ),
          const Divider(height: 0),
          //si queremos, añadir tema de notificaciones
          ListTile(
            title: Text("report".tr(context),),
            leading: const Icon(Icons.assignment),
            onTap: () {
              widget.controladorPresentacion.mostrarReportBug(context);
            },
          ),
          const Divider(height: 0),
          ListTile(
            title: Text("bloqued-see".tr(context),),
            leading: const Icon(Icons.block),
            onTap: () {
              widget.controladorPresentacion.mostrarBlockedUsers(context);
            },
          ),
        ],
      ),
    );
  }

  void _signOut(BuildContext context) {
    _controladorPresentacion.logout(context);
  }

  void _showLanguageSelector(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('select'.tr(context)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildLanguageOption(context, Locale('en')),
              _buildLanguageOption(context, Locale('ca')),
              _buildLanguageOption(context, Locale('es')),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLanguageOption(BuildContext context, Locale locale) {
    final languageCode = locale.languageCode;
    String languageName;
    if (languageCode == 'en') languageName = 'english'.tr(context);
    else if (languageCode == 'ca') languageName = 'catalan'.tr(context);
    else languageName = 'spanish'.tr(context);
    return ListTile(
      title: Text(languageName),
      onTap: () {
        changeLanguage(locale);
      },
    );
  }
  
  void changeLanguage(Locale locale) {
    _controladorPresentacion.changeLanguage(locale);
    Navigator.of(context).pop();
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text('restart_for_changes'.tr(context)),
        backgroundColor: Colors.green,
      ),
    );
  }

  void checkPrivacy(String uid) async {
    bool privateStatus = await _controladorPresentacion.checkPrivacy(uid);
    if (mounted) {
      setState(() {
        privat = privateStatus;
      });
    }
  }

}
