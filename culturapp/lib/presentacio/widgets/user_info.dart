import 'package:culturapp/domain/models/actividad.dart';
import 'package:culturapp/presentacio/screens/vista_lista_actividades.dart';
import 'package:culturapp/translations/AppLocalizations';
import 'package:flutter/material.dart';
import 'package:culturapp/presentacio/controlador_presentacio.dart';

class UserInfoWidget extends StatefulWidget {
  final ControladorPresentacion controladorPresentacion;
  final String username;
  final bool owner;
  const UserInfoWidget({Key? key, required this.controladorPresentacion, required this.username, required this.owner}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _UserInfoWidgetState createState() => _UserInfoWidgetState(this.controladorPresentacion);
}

class _UserInfoWidgetState extends State<UserInfoWidget> {
  String _selectedText = "'Historico actividades'";
  int _selectedIndex = 0;
  late ControladorPresentacion _controladorPresentacion;
  late String _usernameFuture;
  late List<Actividad> activitats = widget.owner ? _controladorPresentacion.getActivitatsUser() : [];
  late List<Actividad> display_list;
  
  _UserInfoWidgetState(ControladorPresentacion controladorPresentacion) {
    _controladorPresentacion = controladorPresentacion;
  }

  @override
  void initState() {
    super.initState();
    _usernameFuture = widget.username;
    display_list = activitats;
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
    return Scaffold(
      body: Center(
        child: FutureBuilder<String?>(
      future: Future.value(_usernameFuture),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Muestra un indicador de carga mientras se obtiene el nombre de usuario
          return Container(
            alignment: Alignment.center,
            // Asigna un tamaño específico al contenedor
            width: 50, // Por ejemplo, puedes ajustar el ancho según tus necesidades
            height: 50, // También puedes ajustar la altura según tus necesidades
            child: const CircularProgressIndicator(color:  Color(0xFFF4692A)),
          );
        } else if (snapshot.hasError) {
          // Muestra un mensaje de error si falla la obtención del nombre de usuario
          return const Text('Error al obtener el nombre de usuario');
        } else {
          // Muestra el nombre de usuario obtenido
          final username = snapshot.data ?? '';
          return _buildUserInfo(username);
        }
      },
    ),
      ));
  }

  Widget _buildUserInfo(String username) {
    //faltaria adaptar el padding en % per a cualsevol dispositiu
    //columna para la parte del username, xp i imagen perfil
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, top: 25, bottom:20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            //imagen
            children: [
              Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    image: DecorationImage(image: NetworkImage(_controladorPresentacion.getUser()!.photoURL!), fit: BoxFit.cover),)
              ),
              const SizedBox(width: 20),
              Padding(
                padding: EdgeInsets.only(top: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //username
                    Text(
                      username,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    //XP
                    Text(
                      '1500 XP',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 4, 
                child:_buildInfoColumn("assisted_events".tr(context), '1'),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 4, 
                child: GestureDetector(
                  onTap: () {
                    widget.controladorPresentacion.mostrarFollows(context, true); 
                  },
                  child: _buildInfoColumn('followers'.tr(context), '12'),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 4, 
                child: GestureDetector(
                  onTap: () {
                    widget.controladorPresentacion.mostrarFollows(context, false); 
                  },
                  child: _buildInfoColumn('following'.tr(context), '40'),
                ),
              ),
              if (widget.owner) ...[
                Container(
                  width: MediaQuery.of(context).size.width / 4, 
                  child: GestureDetector(
                    onTap: () {
                      widget.controladorPresentacion.mostrarPendents(context); 
                    },
                    child: _buildInfoColumn("friendship_requests_title".tr(context), '40'),
                  ),
                ),
              ],
            ],
          ),
        ),
        Expanded(
          child: DefaultTabController(
            length: 2,
            child: Column(
              children: [
                TabBar(
                  tabs: [
                    Tab(text: "assisted_events".tr(context)),
                    Tab(text: "badges".tr(context)),
                  ],
                  indicatorColor: const Color(0xFFF4692A),
                  labelColor: const Color(0xFFF4692A),

                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      Expanded(
                        child: ListView(
                          controller: ScrollController(),
                          children: [
                            SizedBox(
                              height: 350,
                              child: ListaActividadesDisponibles(actividades: activitats, controladorPresentacion: _controladorPresentacion,),
                            ),
                          ],
                        ),
                      ),
                      Text("Insignias"),
                    ],
                  ),
                ),
              ],
            ),
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
            Icon(icon, color: isSelected ? const Color(0xFFF4692A) : Colors.white),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? const Color(0xFFF4692A) : Colors.white,
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
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold,),
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