import "package:cloud_firestore/cloud_firestore.dart";
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
  late Usuari _usuari;
  late xatAmic xat;
  Color taronjaFluix = const Color.fromRGBO(240, 186, 132, 1);
  Color grisFluix = const Color.fromRGBO(211, 211, 211, 0.5);
  //late Future<List<Message>> missatges;

  _XatAmicScreen(
    ControladorPresentacion controladorPresentacion, Usuari usuari) {
    _controladorPresentacion = controladorPresentacion;
    _usuari = usuari;
    xat = xatMock;
    //crida al back per agafar el xat amb el receiver(usuari i jo)
    //missatges = xat.missatges!;
    //missatges = _controladorPresentacion.getMessages(_usuari.id);
  }

  final TextEditingController _controller = TextEditingController();

  void _handleSubmitted(String text) {
    _controller.clear();

    setState(() {
      //crida al back per enviar un missatge
      String time = Timestamp.now().toDate().toIso8601String();
      _controladorPresentacion.addMessage(_usuari.id, time, text);
      /*missatges.insert(
        0,
        Message(text: text, sender: 'Me', timeSended: '10:00'),
      );*/
    });
  }

  Future<String> assignaUsernames(String id) async {
    return await _controladorPresentacion.getUsername(id);
  }

  Future<List<Message>> getMessage() async {
    List<Message> msg = await  _controladorPresentacion.getMessages(_usuari.id);
    return msg;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Message>>(
      future: getMessage(),
      builder: (BuildContext context, AsyncSnapshot<List<Message>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Mentres no acaba el future
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}'); // Si hi ha hagut algun error
        } else {
          List<Message> missatges = snapshot.data!;
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
                      itemCount: missatges.length,
                      itemBuilder: (context, index) {
                        return ChatBubble(
                          userName: missatges[index].sender,
                          message: missatges[index].text,
                          time: missatges[index].timeSended,
                        );
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
      }
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
                onSubmitted: _handleSubmitted,
                decoration:
                    const InputDecoration.collapsed(hintText: 'Send a message'),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: () => _handleSubmitted(_controller.text),
            ),
          ],
        ),
      ),
    );
  }
}
