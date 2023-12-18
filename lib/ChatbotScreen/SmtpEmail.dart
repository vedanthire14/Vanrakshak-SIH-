import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class EmailSenderPage extends StatefulWidget {
  @override
  _EmailSenderPageState createState() => _EmailSenderPageState();
}

class _EmailSenderPageState extends State<EmailSenderPage> {
  final String username = 'vanrakshash@gmail.com';
  final String password = 'ighd ptyq orsm tykf';
  final emailController = TextEditingController();
  final descriptionController = TextEditingController();
  File? attachment;

  void pickAttachment() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      attachment = File(result.files.single.path!);
    }
  }

  void sendEmail() async {
    final smtpServer = gmail(username, password);

    // Create the email message
    final message = Message()
      ..from = Address(username, 'Your Name')
      ..recipients.add(emailController.text)
      ..subject = 'Flutter Email with Attachment'
      ..text = descriptionController.text;

    if (attachment != null) {
      message.attachments.add(FileAttachment(attachment!));
    }

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
      // ... Show dialog for success
    } on MailerException catch (e) {
      print('Message not sent.');
      // ... Show dialog for error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Send Email with Attachment'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Recipient Email'),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: pickAttachment,
              child: Text('Pick PDF Attachment'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: sendEmail,
              child: Text('Send Email'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}
