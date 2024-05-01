import "package:cloud_firestore/cloud_firestore.dart";
import "package:culturapp/domain/converters/convert_date_format.dart";
import "package:culturapp/domain/models/message.dart";
import "package:culturapp/domain/models/usuari.dart";
import "package:culturapp/domain/models/xat_amic.dart";
import "package:culturapp/presentacio/controlador_presentacio.dart";
import "package:culturapp/presentacio/widgets/chat_bubble.dart";
import "package:flutter/material.dart";

class XatAmicScreen extends StatefulWidget {
  final ControladorPresentacion controladorPresentacion;
  final Usuari usuari;

  const XatAmicScreen(
      {Key? key, required this.controladorPresentacion, required this.usuari})
      : super(key: key);

  @override
  State<XatAmicScreen> createState() =>
      _XatAmicScreen(this.controladorPresentacion, this.usuari);
}

class _XatAmicScreen extends State<XatAmicScreen> {
  late ControladorPresentacion _controladorPresentacion;
  late Usuari _usuari; //usuari utilitzant l'aplicació
  late xatAmic xat;
  late List<Message> messages;

  Color taronjaFluix = const Color.fromRGBO(240, 186, 132, 1);
  Color grisFluix = const Color.fromRGBO(211, 211, 211, 0.5);

  _XatAmicScreen(
      ControladorPresentacion controladorPresentacion, Usuari usuari) {
    _controladorPresentacion = controladorPresentacion;
    _usuari = usuari;
  }

  final TextEditingController _controller = TextEditingController();

  void _sendMessage(String text) {
    //enviar missatge, jo envio missatge

    if (text.isNotEmpty) {
      _controller.clear();

      setState(() {
        //crida al back per enviar un missatge
        String time = Timestamp.now().toDate().toIso8601String();
        _controladorPresentacion.addXatMessage(_usuari.id, time, text);

        messages.insert(
          messages.length,
          Message(text: text, sender: 'Me', timeSended: time),
        );
      });
    }
  }

  void assignaUsernames(Message message, void Function(String) callback) {
    _controladorPresentacion.getUsername(message.sender).then((username) {
      if (username == null) {
        // Handle the case where username is null
        callback('Default');
      } else {
        callback(username);
      }
    });
  }

  Future<List<Message>> getMessage() async {
    List<Message> msg =
        await _controladorPresentacion.getXatMessages(_usuari.id);
    return msg;
  }

  Future<String> getUserNameById(String id) {
    return _controladorPresentacion.getUsername(id);
  }

  Message convertIntoRigthVersion(Message message) {
    //una funcio que converteix el temps en apropiat i el id del ususari en el nom de l'usuari
    assignaUsernames(message, (username) {
      message.sender = username;
    });

    message.timeSended = convertTimeFormat(message.timeSended);
    return message;
  }

  List<Message> convertData(List<Message> messagelist) {
    return messagelist.map(convertIntoRigthVersion).toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Message>>(
      future: getMessage(),
      builder: (BuildContext context, AsyncSnapshot<List<Message>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingScreen();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}'); // Si hi ha hagut algun error
        } else {
          //convertim els missatges en la versió correcta quan els agafem del backend i ens ho guardem al frontend
          messages = convertData(snapshot.data!);
          return Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: _buildAppBar(),
            body: Column(
              children: [
                Expanded(
                  child: Container(
                    color: grisFluix,
                    alignment: Alignment.topCenter,
                    child: ListView.builder(
                      reverse: true,
                      shrinkWrap: true,
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        return _buildChatBubble(messages[index]);
                      },
                    ),
                  ),
                ),
                const Divider(height: 1.0),
                Container(
                  decoration: BoxDecoration(color: Theme.of(context).cardColor),
                  child: _bottomInputField(),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Widget _buildLoadingScreen() {
    return const SizedBox(
      width: 5,
      height: 5,
      child: CircularProgressIndicator(
        strokeWidth: 1,
        valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.orange,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
        onPressed: () => _controladorPresentacion.mostrarXats(context),
      ),
      title: Row(
        children: [
          CircleAvatar(
            backgroundImage: AssetImage(_usuari.image),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _usuari.nom,
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(
            Icons.more_vert,
            color: Colors.white,
          ),
          onPressed: () {
            //ns si més endevant estaria per poder reportar?
            _controladorPresentacion.mostrarInfoAmic(context, _usuari);
          },
        ),
      ],
    );
  }

  Widget _buildChatBubble(message) {
    return ChatBubble(
      userName: message.sender,
      message: message.text,
      time: message.timeSended,
    );
  }

  Widget _bottomInputField() {
    return IconTheme(
      data: const IconThemeData(color: Colors.orange),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: _controller,
                onSubmitted: _sendMessage,
                decoration:
                    const InputDecoration.collapsed(hintText: 'Send a message'),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: () => _sendMessage(_controller.text),
            ),
          ],
        ),
      ),
    );
  }
}
