import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart' as constant;
import 'package:firebase_auth/firebase_auth.dart';

class ChatScreen extends StatefulWidget {
  static final String id = "ChatScreen";

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController _textController = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _fS = FirebaseFirestore.instance;
  String message = "";
  User loggedInUser;

  void getCurrentUser() async {
    try {
      final User user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  initState() {
    getCurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);
                //Implement logout functionality
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            StreamBuilderWidget(
              fS: _fS,
              loggedInUser: this.loggedInUser,
            ),
            Container(
              decoration: constant.kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      style: constant.kNormalBlackTextStyle,
                      controller: _textController,
                      onChanged: (value) {
                        message = value;
                        //Do something with the user input.
                      },
                      decoration: constant.kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      if (message.isNotEmpty) {
                        _textController.clear();
                        _fS.collection("messages").add({
                          "text": message,
                          "sender": loggedInUser.email,
                          "time": FieldValue.serverTimestamp()
                        });
                        setState(() {});
                      }
                    },
                    child: Text(
                      'Send',
                      style: constant.kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StreamBuilderWidget extends StatelessWidget {
  const StreamBuilderWidget({
    Key key,
    @required this.loggedInUser,
    @required FirebaseFirestore fS,
  })  : _fS = fS,
        super(key: key);

  final FirebaseFirestore _fS;
  final loggedInUser;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _fS.collection("messages").orderBy("time").snapshots(),
      builder: ((context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final messages = snapshot.data.docs.reversed;
        List<MessageBubble> messageBubbleWidgets = [];
        for (var msg in messages) {
          final messageText = msg["text"];
          final messageComeFrom = msg["sender"];
          final currentUser = loggedInUser.email;

          if (currentUser == messageComeFrom) {}

          messageBubbleWidgets.add(MessageBubble(
              sender: '$messageComeFrom',
              text: '$messageText',
              isMe: currentUser == messageComeFrom));
        }
        return Expanded(
            child: ListView(reverse: true, children: messageBubbleWidgets));
      }),
    );
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble(
      {@required this.sender, @required this.text, @required this.isMe});

  final String sender;
  final String text;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            '$sender',
            style: constant.kNormalBlackTextStyle.copyWith(fontSize: 12.0),
          ),
          Material(
            elevation: 5,
            borderRadius: isMe
                ? BorderRadius.all(Radius.circular(30))
                    .copyWith(topRight: Radius.circular(0))
                : BorderRadius.all(Radius.circular(30))
                    .copyWith(topLeft: Radius.circular(0)),
            color: isMe
                ? constant.kPrimaryButtonColor
                : constant.kSecondaryButtonColor,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                "$text",
                textAlign: TextAlign.center,
                style: isMe
                    ? constant.kNormalWhiteTextStyle.copyWith(
                        fontWeight: FontWeight.bold,
                      )
                    : constant.kNormalBlackTextStyle,
              ),
            ),
          )
        ],
      ),
    );
  }
}
