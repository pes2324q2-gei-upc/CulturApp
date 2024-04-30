import "package:culturapp/presentacio/controlador_presentacio.dart";
import "package:culturapp/presentacio/widgets/chat_bubble.dart";
import "package:flutter/material.dart";

class XatGrupScreen extends StatefulWidget {
  final ControladorPresentacion controladorPresentacion;

  const XatGrupScreen({Key? key, required this.controladorPresentacion})
      : super(key: key);

  @override
  State<XatGrupScreen> createState() =>
      _XatGrupScreen(this.controladorPresentacion);
}

class _XatGrupScreen extends State<XatGrupScreen> {
  late ControladorPresentacion _controladorPresentacion;
  Color taronjaFluix = const Color.fromRGBO(240, 186, 132, 1);
  Color grisFluix = const Color.fromRGBO(211, 211, 211, 0.5);

  _XatGrupScreen(ControladorPresentacion controladorPresentacion) {
    _controladorPresentacion = controladorPresentacion;
  }

  List<Message> missatges = [
    Message(text: 'text', sender: 'Rosa'),
    Message(text: 'text llarggggggggggggggggggg', sender: 'Rosa'),
    Message(text: 'text', sender: 'Me'),
    Message(text: 'text', sender: 'Rosa'),
    Message(text: 'text', sender: 'Me'),
    Message(text: 'text', sender: 'Rosa'),
    Message(text: 'text', sender: 'Me'),
    Message(text: 'text', sender: 'Rosa'),
    Message(text: 'text', sender: 'Andreu'),
  ];

  final TextEditingController _controller = TextEditingController();

  void _handleSubmitted(String text) {
    _controller.clear();
    setState(() {
      missatges.insert(0, Message(text: text, sender: 'Me'));
    });
  }

  @override
  Widget build(BuildContext context) {
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
                    time: "10:00 AM",
                    //s'ha de tocar de tal manera que si soc jo l'usuari, es fiqui
                    //a la dreta, mentre que si es qualsevol altre persona es fica a l'esquerra
                  );
                },
              ),
            ),
          ),
          const Divider(height: 1.0),
          Container(
            decoration: BoxDecoration(color: Theme.of(context).cardColor),
            child: _BottomInputField(),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFFF4692A),
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: const Row(
        children: [
          CircleAvatar(
            backgroundImage: AssetImage('assets/userImage.png'),
          ),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Nom del grup',
                style: TextStyle(color: Colors.white),
              ),
              Text(
                'Participants',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.0,
                ),
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
            //de moment res
          },
        ),
      ],
    );
  }

  Widget _BottomInputField() {
    return IconTheme(
      data: IconThemeData(color: const Color(0xFFF4692A)),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: _controller,
                onSubmitted: _handleSubmitted,
                decoration:
                    InputDecoration.collapsed(hintText: 'Send a message'),
              ),
            ),
            IconButton(
              icon: Icon(Icons.send),
              onPressed: () => _handleSubmitted(_controller.text),
            ),
          ],
        ),
      ),
    );
  }
}

class Message {
  final String text;
  final String sender;

  Message({required this.text, required this.sender});
}
