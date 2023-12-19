import 'package:flutter/material.dart';
import 'package:dialogflow_flutter/googleAuth.dart';
import 'package:dialogflow_flutter/dialogflowFlutter.dart';

class ChatBotScreen extends StatefulWidget {
  @override
  _ChatBotScreenState createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  final messageInsert = TextEditingController();
  List<Map> messsages = [
    {"data": 1, "message": "Hi, how can I help you?"}
  ];

  void response(query) async {
    AuthGoogle authGoogle =
        await AuthGoogle(fileJson: "assets/dialog_flow_auth.json").build();
    DialogFlow dialogflow = DialogFlow(authGoogle: authGoogle, language: "en");
    AIResponse aiResponse = await dialogflow.detectIntent(query);
    setState(() {
      messsages.insert(0, {
        "data": 0,
        "message": aiResponse.getListMessage()![0]["text"]["text"][0].toString()
      });
    });
  }

  void sendMessage(String message) {
    if (message.isEmpty) {
      print("empty message");
    } else {
      setState(() {
        messsages.insert(0, {"data": 1, "message": message});
      });
      response(message);
      messageInsert.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 70,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        elevation: 10,
        title: Text("Dialog Flow Chatbot"),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Flexible(
                child: ListView.builder(
                    reverse: true,
                    itemCount: messsages.length,
                    itemBuilder: (context, index) => chat(
                        messsages[index]["message"].toString(),
                        messsages[index]["data"]))),
            Divider(
              height: 6.0,
            ),
            buildInputArea(),
            buildPredefinedQuestionButtons(),
          ],
        ),
      ),
    );
  }

  Widget buildInputArea() {
    return Container(
      padding: EdgeInsets.only(left: 15.0, right: 15.0, bottom: 20),
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: <Widget>[
          Flexible(
              child: TextField(
            controller: messageInsert,
            decoration: InputDecoration.collapsed(
                hintText: "Send your message",
                hintStyle:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)),
          )),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 4.0),
            child: IconButton(
                icon: Icon(
                  Icons.send,
                  size: 30.0,
                ),
                onPressed: () => sendMessage(messageInsert.text)),
          )
        ],
      ),
    );
  }

  Widget buildPredefinedQuestionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        ElevatedButton(
          onPressed: () => sendMessage("Chinmay"),
          child: Text("Chinmay"),
        ),
        ElevatedButton(
          onPressed: () => sendMessage("Hello"),
          child: Text("Hello"),
        ),
      ],
    );
  }

  Widget chat(String message, int data) {
    return Container(
      padding: EdgeInsets.only(left: 14, right: 14),
      child: Row(
        mainAxisAlignment:
            data == 1 ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Flexible(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: data == 1 ? Colors.blue : Colors.grey.shade200,
              ),
              padding: EdgeInsets.all(16),
              child: Text(
                message,
                style: TextStyle(fontSize: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
