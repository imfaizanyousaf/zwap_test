import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:zwap_test/model/user.dart';
import 'package:zwap_test/utils/api.dart';
import 'package:zwap_test/utils/image_upload_service.dart';
import 'package:zwap_test/view/components/buttons/primaryLarge.dart';
import 'package:zwap_test/view/components/textfields/outlined.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  //create text editing controllers for all the text fields
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  bool _validFirstName = true;
  bool _validLastName = true;
  bool _validEmail = true;
  bool dataUpdated = false;
  ImageUploadService imageUploadService = ImageUploadService();
  final _addFormKey = GlobalKey<FormState>();

  File? _image;
  final picker = ImagePicker();
  User? currentUser;
  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  void getProfileData() async {
    // get user data from the server
    api user = api();
    currentUser = await user.getUser(null);
    if (mounted) {
      setState(() {
        _firstNameController.text = currentUser!.firstName;
        _lastNameController.text = currentUser!.lastName;
        _emailController.text = currentUser!.email;
      });
    }
  }

  @override
  initState() {
    super.initState();

    getProfileData();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            GestureDetector(
              onTap: () {
                getImage();
              },
              child: CircleAvatar(
                  radius: 50,
                  backgroundImage: _image == null
                      ? NetworkImage(currentUser!.logo ??
                          "https://avatar.iran.liara.run/username?username=${currentUser!.firstName}+${currentUser!.lastName}")
                      : FileImage(_image!) as ImageProvider),
            ),
            SizedBox(
              height: 16,
            ),
            TextFieldOutlined(
              label: "First Name",
              errorMessage: "First name is required!",
              controller: _firstNameController,
              onChanged: (_firstNameController) {
                isFirstNameValid();
                if (_validFirstName &&
                    currentUser != null &&
                    currentUser!.firstName != _firstNameController) {
                  setState(() {
                    dataUpdated = true;
                  });
                } else {
                  setState(() {
                    dataUpdated = false;
                  });
                }
              },
              valid: _validFirstName,
            ),
            SizedBox(
              height: 16,
            ),
            TextFieldOutlined(
              label: "Last Name",
              errorMessage: "Last name is required!",
              controller: _lastNameController,
              onChanged: (_lastNameController) {
                isLastNameValid();
                if (_validLastName &&
                    currentUser != null &&
                    currentUser!.lastName != _lastNameController) {
                  setState(() {
                    dataUpdated = true;
                  });
                } else {
                  setState(() {
                    dataUpdated = false;
                  });
                }
              },
              valid: _validLastName,
            ),
            SizedBox(
              height: 16,
            ),
            TextFieldOutlined(
              label: "Email",
              errorMessage: _emailController.text.isEmpty
                  ? "Email is required"
                  : "Invalid Email",
              controller: _emailController,
              valid: _validEmail,
              keyboard: TextInputType.emailAddress,
              onChanged: (_emailController) {
                isEmailValid();
                if (_validEmail &&
                    currentUser != null &&
                    currentUser!.email != _emailController) {
                  setState(() {
                    dataUpdated = true;
                  });
                } else {
                  setState(() {
                    dataUpdated = false;
                  });
                }
              },
            ),
            SizedBox(
              height: 16,
            ),
          ]),
        ),
      ),
      persistentFooterButtons: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: PrimaryLarge(
              disabled: !_validFirstName ||
                  !_validLastName ||
                  !_validEmail ||
                  !dataUpdated,
              text: "Save",
              onPressed: !dataUpdated
                  ? null
                  : () async {
                      api user = api();
                      User currentUser = await user.getUser(null);
                      currentUser.firstName = _firstNameController.text;
                      currentUser.lastName = _lastNameController.text;
                      currentUser.email = _emailController.text;

                      String response = await user.updateUser(currentUser,
                          filePath: _image!.path);

                      if (response == '200') {
                        //show a dialog to the user that user updated successfully
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Success"),
                              content: Text("User updated successfully"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("OK"),
                                ),
                              ],
                            );
                          },
                        );
                      } else if (response == '302') {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Email Already Exists"),
                              content: Text("Try a different Email"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("OK"),
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        //show a dialog to the user that user updated successfully
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Error"),
                              content: Text("An error occurred"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("OK"),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    }),
        ),
      ],
    );
  }

  void isEmailValid() {
    String email = _emailController.text.trim();

    if (email.isEmpty) {
      setState(() {
        _validEmail = false;
      });
      return;
    }
    RegExp emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');

    setState(() {
      _validEmail = emailRegex.hasMatch(email);
    });
  }

  void isFirstNameValid() {
    String firstName = _firstNameController.text.trim();

    if (firstName.isEmpty) {
      setState(() {
        _validFirstName = false;
      });
      return;
    }

    setState(() {
      _validFirstName = true;
    });
  }

  void isLastNameValid() {
    String lastName = _lastNameController.text.trim();

    if (lastName.isEmpty) {
      setState(() {
        _validLastName = false;
      });
      return;
    }

    setState(() {
      _validLastName = true;
    });
  }
}
