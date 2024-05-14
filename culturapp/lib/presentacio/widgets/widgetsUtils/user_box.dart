import 'package:culturapp/domain/models/usuari.dart';
import 'package:culturapp/presentacio/controlador_presentacio.dart';
import 'package:culturapp/translations/AppLocalizations';
import 'package:flutter/material.dart';

class userBox extends StatefulWidget {
  final String text;
  final bool recomm;
  final String type;
  final String popUpStyle;
  final String placeReport;
  final ControladorPresentacion controladorPresentacion;
  const userBox({super.key, required this.text, required this.recomm, required this.type, required this.popUpStyle, required this.placeReport, required this.controladorPresentacion,});

  @override
  State<userBox> createState() => _userBoxState();
}

class _userBoxState extends State<userBox> {
  bool _showButtons = true;
  String _action = "";
  late final Color popUpColorBackground;
  late final Color popUpColorText;

  @override
  void initState() {
    super.initState();
    if (widget.popUpStyle == "orange") {
      popUpColorBackground = const Color.fromARGB(199, 250, 141, 90).withOpacity(1);
      popUpColorText = Colors.white;
    } else {
      popUpColorBackground = Colors.white;
      popUpColorText = Colors.black;
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        Usuari usuari = await widget.controladorPresentacion.getUserByName(widget.text);
        widget.controladorPresentacion.mostrarAltrePerfil(context, usuari);
      },
      child: Container(
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
                if (widget.controladorPresentacion.getUsername() != widget.text) ...[
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
                  ] else if(widget.type == 'followerRequestSend') ...[
                    _buildPopUpMenuFollowerRequestSend(),
                  ] else if(widget.type == 'reportUserBlocked') ...[
                    _buildPopUpMenuReportUserBlocked(),
                  ] else if(widget.type == 'requested') ...[
                    Row(
                      children: [Text(_action = "request_sent".tr(context)),]
                    ),
                  ],
                ],
              ],  
            ),
          ],
        ),
      ),
    );
  }

  void _handleButtonPress(String action, String text, String placeReport) {
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
      widget.controladorPresentacion.mostrarReportUser(context, text, placeReport);
    } else if (action == "unblock") {
      //widget.controladorPresentacion.unblockUser(text);
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
                    _action = "request_rejected".tr(context);
                    _handleButtonPress("delete", widget.text, "null");
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
                    _action = "request_accepted".tr(context);
                    _handleButtonPress("accept", widget.text, "null");
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
                  _action = "request_sent".tr(context);
                  _handleButtonPress("create", widget.text, "null");
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
      "add_to_followings".tr(context),
      "remove_from_followers".tr(context),
      "block_user".tr(context),
    ]);
  }

  Widget _buildPopUpMenuFollowerRequestSend() {
    return _buildPopupMenu([
      "delete_friendship_request_sent".tr(context),
      "remove_from_followers".tr(context),
      "block_user".tr(context),
    ]);
  }

  Widget _buildPopUpMenuFollowerFollowed() {
    return _buildPopupMenu([
      "remove_from_followers".tr(context),
      "block_user".tr(context),
    ]);
  }

  Widget _buildPopUpMenuFollowing() {
    return _buildPopupMenu([
      "remove_from_followings".tr(context),
      "block_user".tr(context),
    ]);
  }

  Widget _buildPopUpMenuReportUser() {
    return _buildPopupMenu([
      "block_user".tr(context),
      "report_user".tr(context),
    ]);
  }

  Widget _buildPopUpMenuReportUserBlocked() {
    return _buildPopupMenu([
      "unblock_user".tr(context),
      "report_user".tr(context),
    ]);
  }

  Future<bool?> confirmPopUp(String dialogContent) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("confirmation".tr(context)),
          content: Text(dialogContent),
          actions: <Widget>[
            TextButton(
              child: Text( "cancel".tr(context)),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: Text("ok".tr(context)),
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
            color: popUpColorBackground,
            itemBuilder: (BuildContext context) => options.map((String option) {
              return PopupMenuItem(
                value: option,
                child:Text(option, style: TextStyle(color: popUpColorText)),
              );
            }).toList(),
            onSelected: (String value) async {
              if (value == "add_to_followings".tr(context)) {
                _action = "request_sent".tr(context);
                _handleButtonPress("create", widget.text, "null");
              } else if (value == "remove_from_followers".tr(context)) {
                final bool? confirm = await confirmPopUp("confirm_delete_follower".trWithArg(context, {"user": widget.text}));
                if(confirm == true) {
                  _action = "follower_deleted".tr(context);
                  _handleButtonPress("delete", widget.text, "null");
                }
              } else if (value == "remove_from_followings".tr(context)) {
                final bool? confirm = await confirmPopUp("confirm_delete_following".trWithArg(context, {"user": widget.text}));
                if(confirm == true) {
                  _action = "following_deleted".tr(context);
                  _handleButtonPress("deleteFollowing", widget.text, "null");
                }
              } else if (value == "delete_friendship_request_sent".tr(context)) {
                final bool? confirm = await confirmPopUp("confirm_delete_friendship_request_sent".trWithArg(context, {"user": widget.text}));
                if(confirm == true) {
                  _action = "friendship_request_deleted".tr(context);
                  _handleButtonPress("deleteFollowing", widget.text, "null");
                }
              } else if (value == "block_user".tr(context)) {
                final bool? confirm = await confirmPopUp("confirm_block_user".trWithArg(context, {"user": widget.text}));
                if(confirm == true) {
                  _action = "user_blocked".tr(context);
                  _handleButtonPress("block", widget.text, "null");
                }
              } else if (value == "unblock_user".tr(context)) {
                final bool? confirm = await confirmPopUp("confirm_unblock_user".trWithArg(context, {"user": widget.text}));
                if(confirm == true) {
                  _action = "user_unblocked".tr(context);
                  _handleButtonPress("unblock", widget.text, "null");
                }
              } else if (value == "report_user".tr(context)) {
                final bool? confirm = await confirmPopUp("confirm_report_user".trWithArg(context, {"user": widget.text}));
                if(confirm == true) {
                  _action = "user_reported".tr(context);
                  _handleButtonPress("report", widget.text, widget.placeReport);
                }
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


  
  
