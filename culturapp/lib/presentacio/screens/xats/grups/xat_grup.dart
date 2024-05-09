import "package:cloud_firestore/cloud_firestore.dart";
import "package:culturapp/domain/converters/convert_date_format.dart";
import "package:culturapp/domain/models/grup.dart";
import "package:culturapp/domain/models/message.dart";
import "package:culturapp/presentacio/controlador_presentacio.dart";
import "package:culturapp/presentacio/widgets/chat_bubble.dart";
import "package:culturapp/translations/AppLocalizations";
import "package:flutter/material.dart";

class XatGrupScreen extends StatefulWidget {
  final ControladorPresentacion controladorPresentacion;
  final Grup grup;

  const XatGrupScreen(
      {Key? key, required this.controladorPresentacion, required this.grup})
      : super(key: key);

  @override
  State<XatGrupScreen> createState() =>
      _XatGrupScreen(this.controladorPresentacion, this.grup);
}

class _XatGrupScreen extends State<XatGrupScreen> {
  late ControladorPresentacion _controladorPresentacion;
  late Grup _grup;
  late List<String> nomParticipants;
  late List<Message> missatges;
  late ScrollController _scrollController;

  Color taronjaVermellos = const Color(0xFFF4692A);
  Color taronjaVermellosFluix = const Color.fromARGB(199, 250, 141, 90);
  Color grisFluix = const Color.fromRGBO(211, 211, 211, 0.5);

  _XatGrupScreen(ControladorPresentacion controladorPresentacion, Grup grup) {
    _controladorPresentacion = controladorPresentacion;
    _grup = grup;
    nomParticipants = [];
    agafarNomsParticipants(_grup.membres);
    missatges = [];
    _scrollController = ScrollController();
    _loadMessages();
  }

  Message convertIntoRigthVersion(Message message) {
    //una funcio que converteix el temps en apropiat i el id del ususari en el nom de l'usuari

    String myName = _controladorPresentacion.getUsername();

    if (message.sender == myName) {
      message.sender = 'Me';
    }

    message.timeSended = convertTimeFormat(message.timeSended);
    return message;
  }

  List<Message> convertData(List<Message> messagelist) {
    return messagelist.map(convertIntoRigthVersion).toList();
  }

  Future<void> _loadMessages() async {
    List<Message> loadedMessages =
        await _controladorPresentacion.getGrupMessages(_grup.id);
    setState(() {
      missatges = convertData(loadedMessages).reversed.toList();
    });
  }

  void agafarNomsParticipants(List<dynamic> participants) async {
    for (int i = 0; i < participants.length; ++i) {
      //s'haurien de conseguir el noms del users
      nomParticipants.add(_grup.membres[i]);
    }
  }

  String truncarString(String noms, int maxLength) {
    if (noms.length <= maxLength) {
      return noms; // Return the original string if it's not longer than maxLength
    } else {
      return '${noms.substring(0, maxLength - 3)}...'; // Truncate and add '...'
    }
  }

  final TextEditingController _controller = TextEditingController();

  void _sendMessage(String text) {
    //enviar missatge, jo

    if (text.isNotEmpty) {
      _controller.clear();
      setState(() {
        //crida al backend per penjar missatge al grup
        String time = Timestamp.now().toDate().toIso8601String();
        _controladorPresentacion.addGrupMessage(_grup.id, time, text);

        time = convertTimeFormat(time);

        missatges.insert(
          missatges.length,
          Message(text: text, sender: 'Me', timeSended: time),
        );
      });
    }
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
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
                itemCount: missatges.length,
                itemBuilder: (context, index) {
                  return _buildChatBubble(missatges[index]);
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
      backgroundColor: taronjaVermellos,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
        onPressed: () => _controladorPresentacion.mostrarXats(context),
      ),
      title: GestureDetector(
        onTap: () {
          _controladorPresentacion.mostrarInfoGrup(context, _grup);
        },
        child: Row(
          children: [
            const CircleAvatar(
              backgroundImage: AssetImage('assets/userImage.png'),
              //AssetImage(_grup.imageGroup),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _grup.nomGroup,
                  style: const TextStyle(color: Colors.white),
                ),
                Text(
                  truncarString(nomParticipants.join(', '), 30),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14.0,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        _showDropdown(),
      ],
    );
  }

  late String itemSelected;

  Widget _showDropdown() {
    return PopupMenuButton<int>(
      icon: const Icon(
        Icons.more_vert,
        color: Colors.white,
      ),
      color: taronjaVermellosFluix.withOpacity(1),
      onSelected: (value) {
        // Handle item selection
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 1,
          child: _buildItemDropdown("Sortir del grup"),
        ),
      ],
    );
  }

  void exitGroup() {
    setState(() {
      String myUsername = _controladorPresentacion.getUsername();
      _grup.membres.remove(myUsername);
      //elimino el meu username del grup

      _controladorPresentacion.updateGrup(_grup.id, _grup.nomGroup,
          _grup.descripcio, _grup.imageGroup, _grup.membres);
      _controladorPresentacion.mostrarXats(context);
      //crida a funcio del back per fer un update de _grup amb els nous parametres
    });
  }

  Widget _buildItemDropdown(String text) {
    return GestureDetector(
      onTap:
          //llamar a función update quitandome el user 'me' de la lista de members
          exitGroup,
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
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
      data: IconThemeData(color: taronjaVermellos),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                maxLines: null,
                controller: _controller,
                onSubmitted: _sendMessage,
                decoration: InputDecoration.collapsed(
                    hintText: 'send_message'.tr(context)),
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
