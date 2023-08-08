import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Controllers/providers/themeprovider.dart';
import '../../modals/Globals.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';
import '../../utils/Global.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({Key? key}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    Contact contact = ModalRoute.of(context)!.settings.arguments as Contact;

    return Scaffold(
      appBar: AppBar(
        title: Text("Details Page"),
        actions: [
          IconButton(
            onPressed: () {
              Provider.of<themeProvider>(context, listen: false).changeTheme();
            },
            icon: Icon(
              Icons.circle,
            ),
          ),
          IconButton(
            onPressed: () async {
              Globals.hidecontact.add(contact);
              Globals.allContacts.remove(contact);

              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/', (route) => false);

              setState(() {});
            },
            icon: Icon(Icons.no_accounts_outlined),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.more_vert,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 50,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 110,
                  ),
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.teal,
                        foregroundImage: (contact.image != null)
                            ? FileImage(contact.image as File)
                            : null,
                      ),
                      FloatingActionButton(
                        mini: true,
                        onPressed: () {},
                        child: Icon(Icons.camera),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () async {
                      await Globals.allContacts.remove(contact);

                      Navigator.of(context)
                          .pushNamedAndRemoveUntil('/', (route) => false);

                      setState(() {});
                    },
                    icon: Icon(Icons.delete),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.edit),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                "${contact.firstName} ${contact.lastName}",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Row(
                children: [
                  Text(
                    "+91 ${contact.phoneNumber}",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Divider(
                thickness: 1,
                color: Colors.black,
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FloatingActionButton(
                    heroTag: null,
                    onPressed: () async {
                      await launchUrl(
                          Uri.parse("tel: +91${contact.phoneNumber}"));
                    },
                    child: Icon(Icons.phone),
                    backgroundColor: Colors.greenAccent,
                    foregroundColor: Colors.white,
                  ),
                  FloatingActionButton(
                    heroTag: null,
                    onPressed: () async {
                      await launchUrl(
                          Uri.parse("sms: +91${contact.phoneNumber}"));
                    },
                    child: Icon(Icons.message),
                    backgroundColor: Colors.amberAccent,
                    foregroundColor: Colors.white,
                  ),
                  FloatingActionButton(
                    heroTag: null,
                    onPressed: () async {
                      await launchUrl(Uri.parse("mailto: ${contact.email}"));
                    },
                    child: Icon(Icons.email),
                    backgroundColor: Colors.lightBlueAccent,
                    foregroundColor: Colors.white,
                  ),
                  FloatingActionButton(
                    heroTag: null,
                    onPressed: () async {
                      await Share.share(
                          "${contact.firstName} ${contact.lastName} : +97 ${contact.phoneNumber}");
                    },
                    child: Icon(Icons.share),
                    backgroundColor: Colors.orangeAccent,
                    foregroundColor: Colors.white,
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Divider(
                thickness: 1,
                color: Colors.black,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
