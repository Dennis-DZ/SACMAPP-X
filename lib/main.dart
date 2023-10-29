import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:flutter_sms/flutter_sms.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'SACMAPP X',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.yellow),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var contactList = <PhoneContact>[];
  var controller = TextEditingController();

  void addContact() async {
    try {
      PhoneContact contact = await FlutterContactPicker.pickPhoneContact();
      contactList.add(contact);
      notifyListeners();
    } catch (error) {}
  }

  void sendMessage() {
    if (contactList.length > 0) {
      var contact = contactList.removeAt(0);
      _sendSMS([contact.phoneNumber.toString()]);
      print(contact);
      notifyListeners();
    }
  }

  Future<void> _sendSMS(List<String> recipients) async {
    try {
      String _result = await sendSMS(
        message: controller.text,
        recipients: recipients,
      );
      // setState(() => _message = _result);
    } catch (error) {
      // setState(() => _message = error.toString());
    }
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = SendPage();
        break;
      case 1:
        page = GroupsPage();
        break;
      case 2:
        page = HelpPage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: Column(
          children: [
            Expanded(
              child: Container(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: page,
              ),
            ),
            BottomNavigationBar(
              items: [
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.house_fill),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.group_solid),
                  label: 'Groups',
                ),
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.question_circle_fill),
                  label: 'Help',
                ),
              ],
              currentIndex: selectedIndex,
              onTap: (value) {
                setState(() {
                  selectedIndex = value;
                });
              },
            ),
          ],
        ),
      );
    });
  }
}

class HelpPage extends StatelessWidget {
  const HelpPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Placeholder();
  }
}

class GroupsPage extends StatelessWidget {
  const GroupsPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView();
  }
}

class SendPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 60),
        child: Center(
          child: Column(children: [
            Title(),
            SizedBox(height: 100),
            Contacts(),
            SizedBox(height: 100),
            Message(),
          ]),
        ),
      ),
    );
  }
}

class Message extends StatelessWidget {
  const Message({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Column(
      children: [
        SizedBox(
          width: 300,
          child: TextField(
            maxLines: 7,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter your message',
            ),
            controller: appState.controller,
          ),
        ),
        SizedBox(height: 20),
        ElevatedButton(
            onPressed: () {
              appState.sendMessage();
            },
            child: Text("Send"))
      ],
    );
  }
}

class Contacts extends StatelessWidget {
  const Contacts({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("To: "),
        Recipients(),
        ElevatedButton(
          child: Icon(CupertinoIcons.person_crop_circle_fill),
          onPressed: () {
            appState.addContact();
          },
        ),
      ],
    );
  }
}

class Recipients extends StatelessWidget {
  const Recipients({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    return SizedBox(
      width: 200,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (var contact in appState.contactList)
              Text(contact.fullName! + ","),
          ],
        ),
      ),
    );
  }
}

class Title extends StatelessWidget {
  const Title({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text("SACMAPP X", style: TextStyle(fontSize: 50));
  }
}
