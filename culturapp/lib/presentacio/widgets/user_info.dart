import 'package:flutter/material.dart';
import 'package:culturapp/presentacio/controlador_presentacio.dart';

class UserInfoWidget extends StatefulWidget {
  final ControladorPresentacion controladorPresentacion;
  final String uid;

  const UserInfoWidget({Key? key, required this.controladorPresentacion, required String this.uid}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _UserInfoWidgetState createState() => _UserInfoWidgetState(this.controladorPresentacion, this.uid);
}

class _UserInfoWidgetState extends State<UserInfoWidget> {
  String _selectedText = 'Historico actividades';
  int _selectedIndex = 0;

  late ControladorPresentacion _controladorPresentacion;
  late String _uid;
  late Future<String?> _usernameFuture;
  
  _UserInfoWidgetState(ControladorPresentacion controladorPresentacion, String uid) {
    _controladorPresentacion = controladorPresentacion;
    _uid = uid;
  }

  @override
  void initState() {
    super.initState();
    _usernameFuture = widget.controladorPresentacion.getUsername(_uid);
  }

  void _onTabChange(int index) {
    setState(() {
      _selectedIndex = index;
      _selectedText = _getLabelText(index);
    });
  }

  //texto que aparece al apretar uno de los botones
  String _getLabelText(int index) {
    switch (index) {
      case 0:
        return 'Historico actividades';
      case 1:
        return 'Insignias o logros';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _usernameFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Muestra un indicador de carga mientras se obtiene el nombre de usuario
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // Muestra un mensaje de error si falla la obtención del nombre de usuario
          return Text('Error al obtener el nombre de usuario');
        } else {
          // Muestra el nombre de usuario obtenido
          final username = snapshot.data ?? '';
          return _buildUserInfo(username);
        }
      },
    );
  }

  Widget _buildUserInfo(String username) {
    //faltaria adaptar el padding en % per a cualsevol dispositiu
    //columna para la parte del username, xp i imagen perfil
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, top: 10, bottom:20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            //imagen
            children: [
              Image.asset(
                'assets/userImage.png',
                width: 100, 
                height: 100, 
              ),
              const SizedBox(width: 10),
              Padding(
                padding: EdgeInsets.only(top: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //username
                    Text(
                      username,
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 5),
                    //XP
                    Text(
                      'XP',
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
              //edit username
              Transform.translate(
                offset: const Offset(0, 5),
                child: Transform.scale(
                  scale: 0.9, 
                  child: IconButton(
                    onPressed: () {
                      _controladorPresentacion.mostrarEditPerfil(this.context, this._uid);
                    },
                    icon: const Icon(Icons.edit, color: Colors.orange),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoColumn('Esdeveniments assistits', '10'),
              _buildInfoColumn('Seguidors', '12'),
              _buildInfoColumn('Seguits', '40'),
            ]
          )
        ),
        //contenedor para elegir ver el historico o las insignias
        Container(
          height: 50,
          color: Colors.orange,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavItem(Icons.event_available, 'Historico actividades', 0),
              _buildNavItem(Icons.stars, 'Insignias', 1),
            ],
          ),
        ),
        //Texto de historico o insignias
        const SizedBox(height: 10),
        Center(
          child: Text(
            _selectedText, 
            style: const TextStyle(fontSize: 16, color: Colors.black),
          ),
        ),
      ],
    );
  }
  
  //NavItem de historico o insignias
  Widget _buildNavItem(IconData icon, String label, int index) {
    bool isSelected = index == _selectedIndex;
    return GestureDetector(
      onTap: () {
        _onTabChange(index);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? Colors.orange : Colors.white),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.orange : Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoColumn(String label, String value) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            value,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold,),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
      ],
    ),
    );
  }
}