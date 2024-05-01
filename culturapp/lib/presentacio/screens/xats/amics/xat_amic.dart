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
  late ScrollController _scrollController;

  Color taronjaFluix = const Color.fromRGBO(240, 186, 132, 1);
  Color grisFluix = const Color.fromRGBO(211, 211, 211, 0.5);

  final TextEditingController _controller = TextEditingController();

  _XatAmicScreen(
      ControladorPresentacion controladorPresentacion, Usuari usuari) {
    _controladorPresentacion = controladorPresentacion;
    _usuari = usuari;
    messages = [];
    _scrollController = ScrollController();
    _loadMessages();
  }

  void _sendMessage(String text) {
    //enviar missatge, jo envio missatge

    if (text.isNotEmpty) {
      _controller.clear();

      setState(() {
        //crida al back per enviar un missatge
        String time = Timestamp.now().toDate().toIso8601String();
        _controladorPresentacion.addXatMessage(_usuari.id, time, text);

        time = convertTimeFormat(time);

        messages.insert(
          messages.length,
          Message(text: text, sender: 'Me', timeSended: time),
        );
      });
    }
  }

  Future<List<Message>> getMessage() async {
    List<Message> msg =
        await _controladorPresentacion.getXatMessages(_usuari.id);
    return msg;
  }

  Message convertIntoRigthVersion(Message message) {
    //una funcio que converteix el temps en apropiat i el id del ususari en el nom de l'usuari

    message.timeSended = convertTimeFormat(message.timeSended);
    return message;
  }

  List<Message> convertData(List<Message> messagelist) {
    return messagelist.map(convertIntoRigthVersion).toList();
  }

  Future<void> _loadMessages() async {
    List<Message> loadedMessages =
        await _controladorPresentacion.getXatMessages(_usuari.id);
    setState(() {
      messages = convertData(loadedMessages);
    });
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _scrollToBottom();
    });

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
                controller: _scrollController,
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
