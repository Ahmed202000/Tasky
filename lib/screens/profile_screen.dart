import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? username;

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  void _loadUserName() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      username = pref.getString("username");
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
              style: TextStyle(fontSize: 20, color: Color(0xFFFFFCFC)),
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
                      backgroundImage: AssetImage(
                        'assets/images/image_profile.png',
                      ),
                      radius: 60,
                      backgroundColor: Colors.transparent,
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Color(0xFF282828),
                        ),
                        child: Icon(
                          Icons.camera_alt,
                          color: Color(0xFFFFFCFC),
                          size: 26,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  '$username',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFFFFFCFC),
                  ),
                ),
                Text(
                  'One task at a time. One step closer.',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFFC6C6C6),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24),
          Text(
            'Profile Info',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w400,
              color: Color(0xFFFFFCFC),
            ),
          ),
        ],
      ),
    );
  }
}
