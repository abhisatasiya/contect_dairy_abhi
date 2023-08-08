import 'package:contact_dairy/modals/Globals.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:contact_dairy/Controllers/providers/themeprovider.dart';
import 'package:contact_dairy/utils/Global.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:local_auth/local_auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final LocalAuthentication auth = LocalAuthentication();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contact"),
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
              bool deviceCanCheck = await auth.canCheckBiometrics;
              bool deviceSupported = await auth.isDeviceSupported();

              try {
                if (deviceCanCheck == true || deviceSupported == true) {
                  bool authenticated = await auth.authenticate(localizedReason: "This page requires your authentication...");

                  if (authenticated == true) {

                    Navigator.of(context).pushNamed('hidden_page');

                  } else {
                    print("======================================");
                    print("Authentication failed....");
                    print("======================================");
                  }
                } else {
                  print("=====================================");
                  print("Device not supported....");
                  print("=====================================");
                }
              } on PlatformException catch (e) {
                print("====================================");
                print("EXCEPTION OCCURED....");
                print("${e.code}");
                print("====================================");
              }
            },
            icon: Icon(
              Icons.more_vert,
            ),
          ),
        ],
      ),
      body: (Globals.allContacts.isNotEmpty)
          ? ListView.builder(
        itemCount: Globals.allContacts.length,
        itemBuilder: (context, i) {
          return ListTile(
            onTap: () {
              Navigator.of(context).pushNamed("details_page",arguments: Globals.allContacts[i]);
            },
            leading: CircleAvatar(
              radius: 30,
              foregroundImage:
              (Globals.allContacts[i].image != null)
                  ? FileImage(
                  Globals.allContacts[i].image as File)
                  : null,
            ),
            title: Text(
              "${Globals.allContacts[i].firstName} ${Globals.allContacts[i].lastName}",
            ),
            subtitle:
            Text("+91 ${Globals.allContacts[i].phoneNumber}"),
            trailing: IconButton(
              onPressed: () async {
                launchUrl(Uri.parse("tel: +91${Globals.allContacts[i].phoneNumber}"));
              },
              icon: Icon(
                Icons.phone,
                color: Colors.green,
              ),
            ),
          );
        },
      )
      : Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.contact_page_outlined,
              size: 100,
            ),
            Text(
              "You have no contact yet...",
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Controllers.firstName.clear();
          Controllers.lastName.clear();
          Controllers.phoneNumber.clear();
          Controllers.email.clear();

          Navigator.of(context).pushNamed('add_contact');
        },
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }
}


