import "package:cloud_firestore/cloud_firestore.dart";
import "package:culturapp/domain/converters/convert_date_format.dart";
import "package:culturapp/domain/models/message.dart";
import "package:culturapp/domain/models/usuari.dart";
import "package:culturapp/domain/models/xat_amic.dart";
import "package:culturapp/presentacio/controlador_presentacio.dart";
import "package:culturapp/presentacio/widgets/chat_bubble.dart";
import "package:culturapp/translations/AppLocalizations";
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
  late Usuari _usuari; //usuari amb qui estic parlant
  late xatAmic xat;
  late List<Message> messages;
  late ScrollController _scrollController;

  Color taronjaVermellos = const Color(0xFFF4692A);
  Color taronjaVermellosFluix = const Color.fromARGB(199, 250, 141, 90);
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
    if (text.isNotEmpty) {
      _controller.clear();

      setState(() {
        //crida al back per enviar un missatge
        String time = Timestamp.now().toDate().toIso8601String();
        String myName = _controladorPresentacion.getUsername();
        _controladorPresentacion.addXatMessage(myName, _usuari.nom, time, text);

        _controladorPresentacion.sendNotificationToAllDevices(
            myName, text, _usuari.devices);

        time = convertTimeFormat(time);

        messages.insert(
          messages.length,
          Message(text: text, sender: 'Me', timeSended: time),
        );
      });
    }
  }

  Future<List<Message>> getMessage() async {
    String myName = _controladorPresentacion.getUsername();
    List<Message> msg =
        await _controladorPresentacion.getXatMessages(myName, _usuari.nom);
    return msg;
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
    String myName = _controladorPresentacion.getUsername();
    List<Message> loadedMessages =
        await _controladorPresentacion.getXatMessages(myName, _usuari.nom);
    setState(() {
      messages = convertData(loadedMessages).reversed.toList();
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
      backgroundColor: taronjaVermellos,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
        onPressed: () => _controladorPresentacion.mostrarXats(context, "Amics"),
      ),
      title: GestureDetector(
        onTap: () {
          _controladorPresentacion.mostrarAltrePerfil(context, _usuari);
        },
        child: Row(
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
      ),
      actions: [
        _buildPopUpMenuNotBlocked(),
      ],
    );
  }

  //Duplicación de código con user_box, revisar como añadirlo a un archivo aparte

  Widget _buildPopUpMenuNotBlocked() {
    return _buildPopupMenu(
        ['block_user'.tr(context), 'report_user'.tr(context)]);
  }

  Widget _buildPopUpMenuBloqued() {
    return _buildPopupMenu(
        ['unblock_user'.tr(context), 'report_user'.tr(context)]);
  }

  Future<bool?> confirmPopUp(String dialogContent) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('confirmation'.tr(context)),
          content: Text(dialogContent),
          actions: <Widget>[
            TextButton(
              child: Text('cancel'.tr(context)),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: Text('ok'.tr(context)),
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
        const SizedBox(width: 8.0),
        PopupMenuButton(
          icon: const Icon(
            Icons.more_vert,
            color: Colors.white,
          ),
          color: taronjaVermellosFluix.withOpacity(1),
          itemBuilder: (BuildContext context) => options.map((String option) {
            return PopupMenuItem(
              value: option,
              child: Text(option, style: const TextStyle(color: Colors.white)),
            );
          }).toList(),
          onSelected: (String value) async {
            String username = _usuari.nom;
            if (value == 'block_user'.tr(context)) {
              final bool? confirm = await confirmPopUp(
                  "block_user_confirm".trWithArg(context, {"user": username}));
              if (confirm == true) {
                //_controladorPresentacion.blockUser(username);
              }
            } else if (value == 'unblock_user'.tr(context)) {
              final bool? confirm = await confirmPopUp("unblock_user_confirm"
                  .trWithArg(context, {"user": username}));
              if (confirm == true) {
                //_controladorPresentacion.unblockUser(username);
              }
            } else if (value == 'report_user'.tr(context)) {
              final bool? confirm = await confirmPopUp(
                  "report_user_confirm".trWithArg(context, {"user": username}));
              if (confirm == true) {
                _controladorPresentacion.mostrarReportUser(
                    context, username, "chat chatId");
              }
            }
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
                    hintText: 'send_a_message'.tr(context)),
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
