// chat screen
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zwap_test/model/user.dart';
import 'package:zwap_test/res/colors/colors.dart';
import 'package:zwap_test/utils/api.dart';
import 'package:zwap_test/view/chat_room.dart';
import 'package:zwap_test/view/notifications.dart';
import 'package:zwap_test/view/profile.dart';

class ChatScreen extends StatefulWidget {
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  User? _currentUser;
  api _api = api();
  List<User>? _allUsers;

  Future<void> _fetchUserData() async {
    User? user = await _api.getUser(null);
    List<User> tempUsers = await _api.getAllUsers();
    if (mounted) {
      setState(() {
        _currentUser = user;
        _allUsers = tempUsers;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: AppColor.background,
        surfaceTintColor: AppColor.background,
        elevation: 1,
        title: Center(
          child: Text(
            'Chats',
            textAlign: TextAlign.center,
            style: GoogleFonts.manrope(
              fontSize: 24,
            ),
          ),
        ),
        leading: Builder(
          builder: (BuildContext context) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileScreen(
                      currentUser: _currentUser!,
                    ),
                  ),
                );
              },
              child: Container(
                margin: EdgeInsets.all(12),
                child: CircleAvatar(
                  radius: 20,
                  backgroundImage: _currentUser != null
                      ? NetworkImage(
                          _currentUser!.logo ??
                              'https://avatar.iran.liara.run/username?username=${_currentUser!.firstName}+${_currentUser!.lastName}',
                        )
                      : NetworkImage(
                          'https://avatar.iran.liara.run/public',
                        ),
                ),
              ),
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.notifications_outlined,
              color: Colors.black,
            ),
            onPressed: () {
              // push to notifications screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NotificationsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: (_allUsers != null || _allUsers != [])
          ? Column(
              children: [
                Expanded(
                  child: FutureBuilder(
                    future: _api.getAllUsers(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return _allUsers != null
                            ? ListView.builder(
                                itemCount: _allUsers!.length,
                                itemBuilder: (context, index) {
                                  return _allUsers![index].id !=
                                          _currentUser!.id
                                      ? ListTile(
                                          leading: CircleAvatar(
                                            backgroundImage:
                                                _currentUser != null
                                                    ? NetworkImage(
                                                        _currentUser!.logo ??
                                                            'https://avatar.iran.liara.run/username?username=${_allUsers![index].firstName}+${_allUsers![index].lastName}',
                                                      )
                                                    : NetworkImage(
                                                        'https://avatar.iran.liara.run/public',
                                                      ),
                                          ),
                                          title: Text(
                                              '${_allUsers![index].firstName} ${_allUsers![index].lastName}'),
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => ChatRoom(
                                                  sender: _currentUser!,
                                                  receiver: _allUsers![index],
                                                ),
                                              ),
                                            );
                                          },
                                        )
                                      : Container();
                                },
                              )
                            : Container();
                      }
                    },
                  ),
                ),
              ],
            )
          : Container(),
    );
  }
}
