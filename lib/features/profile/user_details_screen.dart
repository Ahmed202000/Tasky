import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/services/preferences_manager.dart';
import '../../core/widgets/custom_text_form_field.dart';

class UserDetailsScreen extends StatefulWidget {
  const UserDetailsScreen({super.key});

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

final GlobalKey<FormState> _key = GlobalKey();
final TextEditingController taskUserNameController = TextEditingController();
final TextEditingController taskMotivationQuoteController =
    TextEditingController();

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  String? username;
  bool isDarkMode = true;

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  void _loadUserName() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {

      username = pref.getString("username");
      taskUserNameController.text = pref.getString('username') ?? "";
      taskMotivationQuoteController.text = pref.getString('motivation_quote') ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Details'),),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _key,

            child: Column(
              children: [
                CustomTextFormField(
                  controller: taskUserNameController,
                  title: 'User Name',
                  hintText: '$username',
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Pleas Enter  User Name";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                CustomTextFormField(
                  controller: taskMotivationQuoteController,
                  title: 'Motivation Quote',
                  hintText: 'One task at a time. One step closer.',
                  maxLines: 5,
                  // validator: (String? value) {
                  //   if (value == null || value.trim().isEmpty) {
                  //     return "Pleas Enter Motivation Quote";
                  //   }
                  //   return null;
                  // },
                ),
                Spacer(),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(MediaQuery.of(context).size.width, 40),
                  ),
                  onPressed: () async{
                    if (_key.currentState!.validate())  {
                      await PreferencesManager().setString("username",taskUserNameController.value.text);
                      await PreferencesManager().setString("motivation_quote", taskMotivationQuoteController.value.text);

                      Navigator.pop(context,true);

                    }
                  },
                  child: Text('Save Changes'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
