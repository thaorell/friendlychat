import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';

void main() {
  runApp(new FriendlychatApp());
}

const String _name = "Charles Thao";

class FriendlychatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "Friendlychat",
      theme:
          defaultTargetPlatform == TargetPlatform.iOS ? iOSTheme : androidTheme,
      home: new ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  State createState() => new ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  //TickerProviderStateMixin ensures vsync
  final List<ChatMessage> messages = <ChatMessage>[];
  final TextEditingController _textController = new TextEditingController();
  @override
  void dispose() {
    // dispose any unused animation because
    // u only need the animation for the latest text
    for (ChatMessage message in messages) message.animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
          "Friendlychat",
        ),
        elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
      ),
      body: Container(
        child: new Column(children: <Widget>[
          //flexible widgets just expand all along any axis
          new Flexible(
              //displaying all the messages as a listview
              child: new ListView.builder(
            padding: new EdgeInsets.all(8.0),
            reverse:
                true, //reverse means that the latest item is actually in the bottom
            itemBuilder: (_, int index) => messages[index],
            itemCount: messages.length,
          )),
          // just a gap
          new Divider(height: 1.0),
          //the bottom will be the text box with the send button
          new Container(
            decoration: new BoxDecoration(
                color: new Color.fromARGB(100, 239, 237, 236)),
            child: _buildTextComposer(),
          ),
        ]),
      ),
    );
  }

  Widget _buildTextComposer() {
    //this is for the text box and the button
//    return new IconTheme(
    //this theme will apply to anything below
//        data: new IconThemeData(color: new Color.fromARGB(255, 67, 164, 121)),
    child:
    return new Container(
        //margin is 15 because iphone XR actually has the weird curvy part of the screen
        margin: const EdgeInsets.symmetric(horizontal: 15.0),
        child: new Row(children: <Widget>[
          new Flexible(
              child: new TextField(
            controller: _textController,
            onSubmitted: _handleSubmitted,
            decoration:
                new InputDecoration.collapsed(hintText: "Send a message"),
          )),
          new Container(
              margin: new EdgeInsets.symmetric(horizontal: 4.0),
              child: Theme.of(context).platform == TargetPlatform.iOS
                  ? new CupertinoButton(
                      child: new Text("Send"),
                      onPressed: () => _handleSubmitted(_textController.text))
                  : new IconButton(
                      icon: new Icon(Icons.send),
                      onPressed: () => _handleSubmitted(_textController.text)))
        ]));
  }

  void _handleSubmitted(String text) {
    _textController.clear();
    if (text != "") {
      ChatMessage msg = new ChatMessage(
        text: text,
        animationController: new AnimationController(
            duration: new Duration(milliseconds: 500), vsync: this),
      );
      setState(() {
        messages.insert(0, msg);
      });
      msg.animationController.forward();
    }
  }
}

class ChatMessage extends StatelessWidget {
  /*
  * How to display a message
  * */
  ChatMessage({this.text, this.animationController});
  final String text;
  final AnimationController animationController;
  @override
  Widget build(BuildContext context) {
    return new SizeTransition(
        sizeFactor: new CurvedAnimation(
            //makes text popping up smoothly omg
            parent: animationController,
            curve: Curves.easeInOutCubic),
        axisAlignment: 0.0,
        child: new Container(
            margin: const EdgeInsets.symmetric(vertical: 10.0),
            child: new Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Container(
                    margin: const EdgeInsets.only(right: 16.00),
                    //Circle Avatar: Avatar in iOS contacts
                    child: new CircleAvatar(child: new Text(_name[0])),
                  ),
                  new Expanded(
                    child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          //Name of user and using the default Flutter theme
                          new Text(_name,
                              style: Theme.of(context).textTheme.subhead),
                          new Container(
                            margin: const EdgeInsets.only(top: 5.0),
                            child: new Text(text),
                          )
                        ]),
                  )
                ])));
  }
}

final ThemeData iOSTheme = new ThemeData(
  primarySwatch: Colors.lightGreen,
  primaryColor: Colors.lightGreen,
  primaryColorBrightness: Brightness.light,
);

final ThemeData androidTheme = new ThemeData(
  primarySwatch: Colors.amber,
  accentColor: Colors.orangeAccent,
);
