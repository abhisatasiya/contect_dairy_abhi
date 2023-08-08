import 'package:flutter/material.dart';
import 'package:contact_dairy/utils/Global.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../../Controllers/providers/themeprovider.dart';
import 'package:url_launcher/url_launcher.dart';

class HiddenPage extends StatefulWidget {
  const HiddenPage({Key? key}) : super(key: key);

  @override
  State<HiddenPage> createState() => _HiddenPageState();
}

class _HiddenPageState extends State<HiddenPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hide Contact"),
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
            onPressed: () {},
            icon: Icon(
              Icons.more_vert,
            ),
          ),
        ],
      ),
      body: (Globals.hidecontact.isNotEmpty)
          ? ListView.builder(
              itemCount: Globals.hidecontact.length,
              itemBuilder: (context, i) {
                return ListTile(
                  onTap: () {
                    Navigator.of(context).pushNamed("details_page",
                        arguments: Globals.hidecontact[i]);
                  },
                  leading: CircleAvatar(
                    radius: 30,
                    foregroundImage: (Globals.hidecontact[i].image != null)
                        ? FileImage(
                            Globals.hidecontact[i].image as File,
                          )
                        : null,
                  ),
                  title: Text(
                    "${Globals.hidecontact[i].firstName} ${Globals.hidecontact[i].lastName}",
                  ),
                  subtitle: Text("+91 ${Globals.hidecontact[i].phoneNumber}"),
                  trailing: IconButton(
                    onPressed: () async {
                      launchUrl(
                        Uri.parse(
                          "tel: +91${Globals.hidecontact[i].phoneNumber}",
                        ),
                      );
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
    );
  }
}
