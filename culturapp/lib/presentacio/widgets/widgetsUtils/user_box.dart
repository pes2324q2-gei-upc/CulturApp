import 'package:culturapp/presentacio/controlador_presentacio.dart';
import 'package:flutter/material.dart';

class userBox extends StatefulWidget {
  final String text;
  final bool recomm;
  final String type;
  final ControladorPresentacion controladorPresentacion;
  const userBox({super.key, required this.text, required this.recomm, required this.type, required this.controladorPresentacion,});

  @override
  State<userBox> createState() => _userBoxState();
}

class _userBoxState extends State<userBox> {
  bool _showButtons = true;
  String _action = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(width: 0.25, color: Colors.grey), top: BorderSide(width: 0.25, color: Colors.grey)),
        color: Colors.white, 
      ),
      child: Row(
        children: [
          if (widget.recomm)
            Column( 
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 10.0),
                  width: 40,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(
                    'assets/categoriarecom.png',
                    fit: BoxFit.fill,
                  ), //Imagen para recomendador */
                ),
              ],
            ),
          Container(
            width: 50,
            height: 50,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue,
            ),
            child: Image.asset(
              'assets/userImage.png', 
              fit: BoxFit.cover, 
            ),
          ),
          const SizedBox(width: 8.0),
          Expanded(
            child: Text(
              widget.text,
              style: const TextStyle(
                fontSize: 16.0,
              ),
            ),
          ),
          Row(
            children: [
              if(widget.type == "pending") ...[
                _buildPendingButtons(),
              ] else if(widget.type == "addSomeone") ...[
                _buildAddSomeoneButton(),
              ] else if(widget.type == "followerNotFollowed") ...[
                _buildPopUpMenuFollowerNotFollowed(),  
              ] else if (widget.type == "followerFollowed") ...[
                _buildPopUpMenuFollowerFollowed(),
              ] else if(widget.type == "following") ...[
                _buildPopUpMenuFollowing(),
              ] else if (widget.type == "reportUser") ...[
                _buildPopUpMenuReportUser(),
              ] else if(widget.type == 'followerSendRequest') ...[
                _buildPopUpMenuFollowerRequestSend(),
              ],
            ],  
          ),
        ],
      ),
    );
  }

  void _handleButtonPress(String action, String text) {
    if (action == "accept") {
      widget.controladorPresentacion.acceptFriend(text);
    } else if (action == "delete") {
      widget.controladorPresentacion.deleteFriend(text);
    } else if (action == "create") {
      widget.controladorPresentacion.createFriend(text);
    } else if (action == "deleteFollowing") {
      widget.controladorPresentacion.deleteFollowing(text);
    } else if (action == "block") {
      //widget.controladorPresentacion.blockUser(text);
    } else if (action == "report") {
      //widget.controladorPresentacion.reportUser(code, text);
    }

    setState(() {
      _showButtons = false;
    });
  }

  Widget _buildPendingButtons() {
        return Row(
          children: [
            if (_showButtons) ...[
              SizedBox(
                width: 50,
                child: TextButton(
                  onPressed: () {
                    _action = "Solicitud rechazada";
                    _handleButtonPress("delete", widget.text);
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFFFFAA80)),
                  ),
                  child: const Text('X', style: TextStyle(fontSize: 24, color: Color.fromARGB(255, 255, 255, 255))),
                ),
              ),
              const SizedBox(width: 8.0),
              SizedBox(
                width: 50,
                child: TextButton(
                  onPressed: () {
                    _action = "Solicitud aceptada";
                    _handleButtonPress("accept", widget.text);
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFFF4692A)),
                  ),
                  child: const Text('✓', style: TextStyle(fontSize: 24, color: Color.fromARGB(255, 255, 255, 255))),
                ),
              ),
          ] else ...[
            Text(_action), 
          ],
        ],
    );
  }

  Widget _buildAddSomeoneButton(){
      return Row(
        children: [ 
          if (_showButtons) ...[
            const SizedBox(width: 8.0),
            SizedBox(
              width: 50,
              child: TextButton(
                onPressed: () {
                  _action = "Solicitud enviada";
                  _handleButtonPress("create", widget.text);
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFFF4692A)),
                ),
                child: const Text('+', style: TextStyle(fontSize: 24, color: Color.fromARGB(255, 255, 255, 255))),
              ),
            ),
          ] else ...[
            Text(_action), 
          ],
        ],
      );
  }

  Widget _buildPopUpMenuFollowerNotFollowed() {
    return _buildPopupMenu([
      'Añadir a amigos',
      'Eliminar de seguidores',
      'Bloquear usuario',
    ]);
  }

  Widget _buildPopUpMenuFollowerRequestSend() {
    return _buildPopupMenu([
      'Eliminar solicitud de amistad enviada',
      'Eliminar de seguidores',
      'Bloquear usuario',
    ]);
  }

  Widget _buildPopUpMenuFollowerFollowed() {
    return _buildPopupMenu([
      'Eliminar de seguidores',
      'Bloquear usuario',
    ]);
  }

  Widget _buildPopUpMenuFollowing() {
    return _buildPopupMenu([
      'Eliminar de seguidos',
      'Bloquear usuario',
    ]);
  }

  Widget _buildPopUpMenuReportUser() {
    return _buildPopupMenu([
      'Bloquear usuario',
      'Reportar usuario'
    ]);
  }

  Future<bool?> confirmPopUp(String dialogContent) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmación'),
          content: Text(dialogContent),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: const Text('Aceptar'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );

  }

  Widget _buildPopupMenu(List<String> options) {
    return Row(
      children: [
        if (_showButtons) ...[
          const SizedBox(width: 8.0),
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (BuildContext context) => options.map((String option) {
              return PopupMenuItem(
                value: option,
                child:Text(option),
              );
            }).toList(),
            onSelected: (String value) async {
              switch(value) {
                case 'Añadir a amigos':
                  _action = "Solicitud enviada";
                  _handleButtonPress("create", widget.text);
                  break;
                case 'Eliminar de seguidores':
                  final bool? confirm = await confirmPopUp("¿Estás seguro de que quieres eliminar a ${widget.text} de tus seguidores?");
                  if (confirm == true) {
                    _action = "Seguidor eliminado";
                    _handleButtonPress("delete", widget.text);
                  }
                  break;
                case 'Eliminar solicitud de amistad enviada':
                  final bool? confirm = await confirmPopUp("¿Estás seguro de que quieres eliminar la solicitud de amistad enviada a ${widget.text}?");
                  if (confirm == true) {
                    _action = "Solicitud de amistad eliminada";
                    _handleButtonPress("deleteFollowing", widget.text);
                  }
                  break;
                case 'Eliminar de seguidos':
                  final bool? confirm = await confirmPopUp("¿Estás seguro de que quieres eliminar a ${widget.text} de tus seguidos?");
                  if(confirm == true) {
                    _action = "Seguido eliminado";
                    _handleButtonPress("deleteFollowing", widget.text);
                  }
                  break;
                case 'Bloquear usuario':
                  final bool? confirm = await confirmPopUp("¿Estás seguro de que quieres bloquear a ${widget.text}?");
                  if(confirm == true) {
                    _action = "Usuario bloqueado";
                    _handleButtonPress("block", widget.text);
                  }
                  break;
                case 'Reportar usuario':
                  _action = "Usuario reportado";
                  _handleButtonPress("report", widget.text);
                  break;
              }
            },
          ),
        ] else ...[
          Text(_action), 
        ],
      ],
    );
  }
}


  
  
