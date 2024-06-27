import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zwap_test/model/request.dart';
import 'package:zwap_test/model/user.dart';
import 'package:zwap_test/res/colors/colors.dart';
import 'package:zwap_test/utils/api.dart';
import 'package:zwap_test/utils/connection.dart';
import 'package:zwap_test/view/components/request_card.dart';
import 'package:zwap_test/view/notifications.dart';
import 'package:zwap_test/view/profile.dart';

class RequestScreen extends StatefulWidget {
  @override
  State<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  User? _currentUser;
  api _api = api();
  List<Request> requestsReceived = [];
  List<Request> requestsSent = [];

  Future<void> _fetchUserData() async {
    User? user = await _api.getUser(null);
    List<Request> tempRequests = await _api.getReceivedRequests();
    List<Request> tempSentRequests = await _api.getSentRequests();
    if (mounted) {
      setState(() {
        _currentUser = user;
        requestsReceived = tempRequests;
        requestsSent = tempSentRequests;
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
      appBar: AppBar(
        backgroundColor: AppColor.background,
        surfaceTintColor: AppColor.background,
        elevation: 1,
        title: Center(
          child: Text(
            'Requests',
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
        bottom: TabBar(
          labelColor: AppColor.primary,
          indicatorColor: AppColor.primary,
          overlayColor:
              MaterialStateProperty.all<Color>(Color.fromARGB(20, 42, 56, 144)),
          tabs: [
            Tab(text: 'Received'),
            Tab(text: 'Sent'),
          ],
        ),
      ),
      body: TabBarView(
        children: [
          CardList(
              tabTitle: 'Received',
              currentUser: _currentUser != null ? _currentUser! : null),
          CardList(
              tabTitle: 'Sent',
              currentUser: _currentUser != null ? _currentUser! : null),
        ],
      ),
    );
  }
}

class CardList extends StatefulWidget {
  final String tabTitle;
  final User? currentUser;

  CardList({required this.tabTitle, required this.currentUser});

  @override
  State<CardList> createState() => _CardListState();
}

class _CardListState extends State<CardList> {
  bool _isConnected = false;
  api _api = api();
  List<Request> requests = [];
  final GlobalKey<_RequestScreenState> _parentKey =
      GlobalKey<_RequestScreenState>();

  void fetchRequests() async {
    List<Request> tempRequests = widget.tabTitle == 'Sent'
        ? await _api.getSentRequests()
        : await _api.getReceivedRequests();

    tempRequests =
        tempRequests.where((element) => element.status == 'pending').toList();
    if (mounted) {
      setState(() {
        requests = tempRequests;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    checkConnection();
  }

  void checkConnection() async {
    bool connected =
        await isConnected(); // Assuming isConnected is defined in connection.dart
    if (mounted) {
      setState(() {
        _isConnected = connected;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return !_isConnected
        ? Scaffold(
            body: Center(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/empty-states/no-connection.svg',
                      width: 250,
                    ),
                    Text('No Internet Connection'),
                    SizedBox(
                      height: 8,
                    ),
                    TextButton(onPressed: checkConnection, child: Text('Retry'))
                  ],
                ),
              ),
            ),
          )
        : Container(
            color: AppColor.background,
            child: FutureBuilder<List<Request>>(
              future: widget.tabTitle == 'Sent'
                  ? _api.getSentRequests()
                  : _api.getReceivedRequests(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child:
                          CircularProgressIndicator()); // Display a loading indicator while waiting for data
                } else if (snapshot.hasError) {
                  return Center(
                      child: Text(
                          "Error: ${snapshot.error}")); // Display an error message if data fetching fails
                } else if (snapshot.data!.isEmpty) {
                  return Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/empty-states/empty-cart.svg',
                        width: 250,
                      ),
                      Text('No Requests Available'),
                    ],
                  ));
                } else {
                  List<Request> filteredRequests = snapshot.data!
                      .where((element) =>
                          element.status == 'pending' ||
                          element.status == 'accepted')
                      .toList();
                  if (filteredRequests.isEmpty) {
                    return Center(child: Text("No Requests available"));
                  }
                  return ListView.builder(
                    itemCount: filteredRequests.length,
                    itemBuilder: (context, index) {
                      return RequestCard(
                          key: ValueKey(filteredRequests[index].id),
                          onRequestUpdated: fetchRequests,
                          requests: filteredRequests[index],
                          currentUser: widget.currentUser);
                    },
                  );
                }
              },
            ),
          );

    // ListView.builder(
    //     itemCount: widget.requests == null ||
    //             widget.requests == [] ||
    //             widget.requests!.isEmpty
    //         ? 0
    //         : widget.requests!.length,
    //     itemBuilder: (BuildContext context, int index) {
    //       return widget.requests == null ||
    //               widget.requests == [] ||
    //               widget.requests!.isEmpty
    //           ? Container()
    //           : RequestCard(
    //               requests: widget.requests![index],
    //               currentUser: widget.currentUser);
    //     },
    //   );
  }
}
