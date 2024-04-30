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

  _SettingsPerfil(ControladorPresentacion controladorPresentacion) {
    _controladorPresentacion = controladorPresentacion;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text(
          'Settings',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          SwitchListTile(
            title: const Text("Privacy"),
            subtitle: const Text("Explanation of what having a private account implies"),
            value: privat,
            onChanged: (bool value) {
              setState(() {
                privat = value;
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
            title: const Text('Change Password'),
            subtitle: const Text("Change your current password"),
            leading: const Icon(Icons.vpn_key),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              // Navigate to change password screen
            },
          ),
          const Divider(height: 0),
          ListTile(
            title: const Text('Sign Out'),
            leading: const Icon(Icons.exit_to_app),
            onTap: () {
              _signOut(context);
            },
          ),
          const Divider(height: 0),
          ListTile(
            title: const Text('Delete Account'),
            subtitle: const Text("Delete account permanently"),
            leading: const Icon(Icons.delete),
            onTap: () {
              // Delete account logic
            },
          ),
          const Divider(height: 0),
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
          title: Text('Select Language'),
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
    if (languageCode == 'en') languageName = 'English';
    else if (languageCode == 'ca') languageName = 'Catalan';
    else languageName = 'Spanish';
    return ListTile(
      title: Text(languageName),
      onTap: () {
        _controladorPresentacion.changeLanguage(locale);
        print('Cambiando idioma a ' + locale.toString());
        Navigator.of(context).pop();
        final scaffoldMessenger = ScaffoldMessenger.of(context);
        scaffoldMessenger.showSnackBar(
          const SnackBar(
            content: Text(('Reinicia!')),
            backgroundColor: Colors.green,
          ),
        );
      },
    );
  }

}
