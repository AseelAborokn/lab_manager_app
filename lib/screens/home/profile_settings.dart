import 'package:flutter/material.dart';
import 'package:lab_manager/models/lab_user.dart';
import 'package:lab_manager/services/auth.dart';
import 'package:lab_manager/shared/loading_spinner.dart';

import '../../shared/results/registration_results.dart';
import '../../shared/utils/functions.dart';
import '../../shared/widgets/background_image.dart';
import '../../shared/widgets/register_text_form_field.dart';

class ProfileSettings extends StatefulWidget {
  const ProfileSettings({Key? key, required this.labUser}) : super(key: key);

  final LabUser labUser;

  @override
  State<ProfileSettings> createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  bool showView = true;
  void toggleView() {
    setState(() => showView = !showView);
  }

  @override
  Widget build(BuildContext context) {
    return (showView)
        ? ProfileSettingsView(toggleView: toggleView, labUser: widget.labUser)
        : ProfileSettingEdit(toggleView: toggleView, labUser: widget.labUser);
  }
}


class ProfileSettingsView extends StatefulWidget {
  const ProfileSettingsView({Key? key, required this.toggleView, required this.labUser}) : super(key: key);
  final Function toggleView;
  final LabUser labUser;

  @override
  State<ProfileSettingsView> createState() => _ProfileSettingsViewState();
}

class _ProfileSettingsViewState extends State<ProfileSettingsView> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade800,
      appBar: AppBar(
        // Title
        title: const Text('Profile Settings', style: TextStyle(color: Colors.teal)),
        centerTitle: true,
        // Application Bar Color
        backgroundColor: Colors.grey.shade900,
      ),
      body: Container(
        decoration: BackGroundImage(),
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 30.0),
        child: Form(
          child: Card(
            color: Colors.black12,
            margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 1.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Text Inputs
                Wrap(
                  runSpacing: 10,
                  children: <Widget>[
                    // username
                    _createListTile("Username:", widget.labUser.username, Icons.person),
                    // PhoneNumber
                    _createListTile("Phone Number:", widget.labUser.phoneNumber, Icons.phone),
                    // CID
                    _createListTile("Card Id:", widget.labUser.cid ?? "", Icons.credit_card),
                  ],
                ),
                const Expanded(child: SizedBox()),
                Container(
                  alignment: Alignment.bottomRight,
                  margin: const EdgeInsets.fromLTRB(0, 0, 10, 10),
                  child: ClipOval(
                    child: Material(
                      // button color
                      color: Colors.teal,
                      child: InkWell(
                        // inkwell color
                        splashColor: Colors.tealAccent,
                        child: const SizedBox(width: 56, height: 56, child: Icon(Icons.edit, color: Colors.white,)),
                        onTap: () { widget.toggleView(); },
                      ),
                    ),
                  )
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Expanded _createListTile(String title, String subtitle, IconData iconData) {
    return Expanded(
        child: ListTile(
          leading: Icon(iconData, color: Colors.teal),
          title: Text(title, style: const TextStyle(color: Colors.teal)),
          subtitle: Text(subtitle, style: const TextStyle(fontSize: 20, color: Colors.white)),
          autofocus: true,
          shape: RoundedRectangleBorder(
            side: const BorderSide(
              color: Colors.greenAccent,
            ),
            borderRadius: BorderRadius.circular(20.0),
          ),
        )
    );
  }
}

class ProfileSettingEdit extends StatefulWidget {
  const ProfileSettingEdit({Key? key, required this.toggleView, required this.labUser}) : super(key: key);
  final Function toggleView;
  final LabUser labUser;

  @override
  State<ProfileSettingEdit> createState() => _ProfileSettingEditState();
}

class _ProfileSettingEditState extends State<ProfileSettingEdit> {
  final _formKey = GlobalKey<FormState>();

  // Text field states
  String? username;
  String? phoneNumber;
  String? cid;
  String errorMessage = "";
  bool errorFound = false;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return (loading) ? const LoadingSpinner() : Scaffold(
      backgroundColor: Colors.grey.shade800,
      appBar: AppBar(
        // Title
        title: const Text('Profile Settings', style: TextStyle(color: Colors.teal)),
        centerTitle: true,
        // Application Bar Color
        backgroundColor: Colors.grey.shade900,
      ),
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BackGroundImage(),
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 30.0),
        child: Form(
          key: _formKey,
          child: Card(
            color: Colors.black12,
            margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 1.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Text Inputs
                Wrap(
                  runSpacing: 10,
                  children: <Widget>[
                    // username
                    RegisterTextFromField(
                      initValue: widget.labUser.username,
                      labelText: "User Name",
                      hintText: "username",
                      iconData: Icons.person,
                      onChanged: (val) => setState(() => username = val),
                      onValidation: (val) => (val == null || val.isEmpty) ? "Invalid username" : null
                    ),
                    // PhoneNumber
                    RegisterTextFromField(
                      initValue: widget.labUser.phoneNumber,
                      labelText: "Phone Number",
                      hintText: "phone number",
                      iconData: Icons.phone,
                      onChanged: (val) => setState(() => phoneNumber = val),
                      onValidation: (val) => (val == null || !validPhoneNumber(phoneNumber ?? widget.labUser.phoneNumber)) ? "Invalid Phone Number" : null
                    ),
                    // CID
                    RegisterTextFromField(
                        initValue: widget.labUser.cid,
                        labelText: "Card Id",
                        hintText: "card id",
                        iconData: Icons.credit_card,
                        onChanged: (val) => setState(() => cid = val),
                        onValidation: (val) => (val == null || !validCid(cid)) ? "Invalid Card Id" : null
                    ),
                  ],
                ),
                // Buttons
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      ClipOval(
                        child: Material(
                          // button color
                          color: Colors.grey,
                          child: InkWell(
                            // inkwell color
                            splashColor: Colors.tealAccent,
                            child: const SizedBox(
                                width: 56,
                                height: 56,
                                child: Icon(Icons.cancel, color: Colors.black,)
                            ),
                            onTap: () { widget.toggleView(); },
                          ),
                        ),
                      ),
                      const SizedBox(width: 50),
                      ClipOval(
                        child: Material(
                          // button color
                          color: Colors.green,
                          child: InkWell(
                            // inkwell color
                            splashColor: Colors.tealAccent,
                            child: const SizedBox(
                                width: 56,
                                height: 56,
                                child: Icon(Icons.save_alt, color: Colors.black,)
                            ),
                            onTap: () async {
                              setState(() => loading = true);
                              if (_formKey.currentState!.validate()) {
                                RegistrationResult result = await AuthService().update(
                                    widget.labUser.uid,
                                    widget.labUser.email,
                                    username ?? widget.labUser.username,
                                    cid ?? widget.labUser.cid,
                                    phoneNumber ?? widget.labUser.phoneNumber,
                                );
                                if (result.labUser != null) {
                                  Navigator.of(context).pop();
                                }
                                else {
                                  setState(() {
                                    errorFound = true;
                                    errorMessage = result.errorMessage ?? "Failed To Update, Please Retry Latter";
                                  });
                                }
                              }
                              setState(() => loading = false);
                            },
                          ),
                        ),
                      ),
                    ],
                  )
                ),
                // Error Message
                Center(
                  child: (errorFound)
                      ? Text(errorMessage, style: const TextStyle(fontSize: 15, color: Colors.deepOrange),)
                      : const Text(""),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


