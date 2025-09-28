import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tasky/core/theme/theme-controller.dart';
import 'package:tasky/core/widgets/custom_svg_picture.dart';
import 'package:tasky/features/profile/user_details_screen.dart';
import 'package:tasky/features/welcome/welcome_screen.dart';

import '../../core/services/preferences_manager.dart';
import '../../main.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? username;
  String? motivationQuote;
  String? userImage;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    setState(() {
      userImage = PreferencesManager().getString("user_image");
      username = PreferencesManager().getString("username");
      motivationQuote = PreferencesManager().getString("motivation_quote") ?? "One task at a time. One step closer.";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              'My Profile',
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ),
          SizedBox(height: 16),
          Center(
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      backgroundImage:
                      userImage == null
                              ? AssetImage('assets/images/image_profile.png')
                              : FileImage(File(userImage!)),
                      radius: 60,
                      backgroundColor: Colors.transparent,
                    ),
                    GestureDetector(
                      onTap: ()  {
                        showImageSourceDialog(context,(XFile file){

                          _saveImage(file);

                          setState(() {
                            userImage = file.path;
                          });
                        });
                      },
                      child: Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Theme.of(context).colorScheme.primaryContainer,
                        ),
                        child: Icon(
                          Icons.camera_alt,
                          // color: Color(0xFFFFFCFC),
                          size: 26,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  '$username',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                Text(
                  '$motivationQuote',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ],
            ),
          ),
          SizedBox(height: 24),
          Text('Profile Info', style: Theme.of(context).textTheme.labelSmall),
          SizedBox(height: 16),
          ListTile(
            contentPadding: EdgeInsets.zero,
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserDetailsScreen()),
              );
              if (result != null && result) {
                _loadData();
              }
            },
            title: Text('User Details'),
            leading: CustomSvgPicture(path: "assets/images/profile_icon.svg"),
            trailing: CustomSvgPicture(
              path: "assets/images/arrow_right_icon.svg",
            ),
          ),
          Divider(thickness: 1),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              'Dark Mode',
              // style: Theme.of(context).textTheme.titleMedium,
            ),
            leading: SvgPicture.asset(
              "assets/images/dark_icon.svg",
              colorFilter: ColorFilter.mode(
                Theme.of(context).colorScheme.secondary,
                BlendMode.srcIn,
              ),
            ),
            trailing: ValueListenableBuilder(
              valueListenable: ThemeController.themeNotifier,
              builder: (context, ThemeMode themeMode, Widget? child) {
                return Switch(
                  value: themeMode == ThemeMode.dark,
                  onChanged: (bool value) async {
                    ThemeController().toggleTheme();
                  },
                );
              },
            ),
          ),
          Divider(thickness: 1),
          ListTile(
            contentPadding: EdgeInsets.zero,
            onTap: () async {
              PreferencesManager().remove("username");
              PreferencesManager().remove("motivation_quote");
              PreferencesManager().remove("tasks");
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return WelcomeScreen();
                  },
                ),
                (Route<dynamic> route) => false,
              );
            },
            title: Text(
              'Log Out',
              //    style: Theme.of(context).textTheme.titleMedium,
            ),
            leading: CustomSvgPicture(path: "assets/images/log_out_icon.svg"),
            trailing: CustomSvgPicture(
              path: "assets/images/arrow_right_icon.svg",
            ),
          ),
        ],
      ),
    );
  }

  void _saveImage(XFile file) async {
    final appDir =await getApplicationDocumentsDirectory();
    final newFile = await File(file.path).copy('${appDir.path}/${file.name}');
    PreferencesManager().setString("user_image", newFile.path);
  }
}

void showImageSourceDialog(BuildContext context, Function(XFile) selectedFile) {
  showDialog(context: context, builder: (BuildContext context){
    return SimpleDialog(
      title: Text("Chose Image Source",
      style: Theme.of(context).textTheme.titleMedium,),
      children: [
        SimpleDialogOption(
          onPressed: () async {
            Navigator.pop(context);
            XFile? image = await ImagePicker().pickImage(
              source: ImageSource.camera,
            );
            if (image != null) {
              selectedFile(image);
            }

          },
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(Icons.camera_alt),
              SizedBox(width: 8,),
              Text("Camera"),
            ],
          ),
        ),

        SimpleDialogOption(
          onPressed: () async {
            Navigator.pop(context);
            XFile? image = await ImagePicker().pickImage(
              source: ImageSource.gallery,
            );
            if (image != null) {
              selectedFile(image);
            }
          },
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(Icons.photo_library),
              SizedBox(width: 8,),
              Text("Gallery"),
            ],
          ),
        ),
      ],
    );
  },
  );
}
