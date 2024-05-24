import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lotus/colors.dart';
import 'package:lotus/entity/user_entity.dart';
import 'package:lotus/settings_page.dart';
class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  File? image;
  User user = User(name:"Jane",surname: "Doe",pregnancyStatus: "12",userId: "1");

  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainPink,
        actions: [
          IconButton(icon: const Icon(Icons.settings),onPressed: () {
            Navigator.push(context,
              MaterialPageRoute(builder: (context) => const Settings()),
            );
          })
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top:50),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 70,
                      backgroundImage: image != null ? FileImage(image!):null,
                      child: image==null
                        ?Icon(
                        Icons.person,
                        size: 50,
                        color: Colors.grey[700],
                      )
                          :null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: pickImage,
                        child: CircleAvatar(
                          radius: 25,
                          backgroundColor: green,
                          child: Icon(
                            Icons.camera_alt,
                            color: coal,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 16),
                Text("${user.name} ${user.surname}",style: const TextStyle(fontSize: 24,fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
