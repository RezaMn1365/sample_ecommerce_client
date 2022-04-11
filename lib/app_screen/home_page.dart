import 'package:flutter_application_1/helpers/navigation.dart' as Navigation;
import 'package:flutter_application_1/helpers/storage/icon_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/network/server_requests.dart'
    as serverRequest;

class HomePage extends StatefulWidget {
  String userName = '';
  String passWord = '';
  String email = '';
  String name = '';

  String uname;

  HomePage(BuildContext context, {Key? key, required this.uname})
      : name = uname,
        super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // getNameValue().then((value) => updateName(value));

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white70,
      appBar: AppBar(
        // backgroundColor: Colors.red,
        title: const Text('Home Page'),
      ),
      // resizeToAvoidBottomInset: false,
      drawer: Drawer(
        elevation: 500,
        // backgroundColor: Colors.red,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.purple,
              ),
              child: Column(
                children: [
                  CircleAvatar(
                      backgroundColor: Colors.brown.shade800,
                      child: Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('images/avatar.png'),
                              fit: BoxFit.fill),
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      )
                      // const Image(
                      //   image: AssetImage('images/avatar.png'),
                      // ),
                      ),
                  const SizedBox(
                    height: 15,
                  ),
                  Center(
                    child: Text(
                      '${widget.name}\'s profile',
                      style: const TextStyle(
                        // color: Colors.red,
                        fontSize: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              tileColor: Colors.grey[200],
              // shape: Border.all(color: Colors.grey),
              leading: const Icon(Icons.account_circle),
              title: const Text('Account Settings'),
              onTap: () {
                Navigation.gotoAccountSettingsPage(context);
              },
            ),
            const SizedBox(
              height: 5,
            ),
            ListTile(
              tileColor: Colors.grey[200],
              // shape: Border.all(color: Colors.grey),
              leading: const Icon(Icons.list),
              title: const Text('Active Sessions'),
              onTap: () {
                Navigation.gotoActiveSessionPage(
                  context,
                );
              },
            ),
            const SizedBox(
              height: 5,
            ),
            ListTile(
              minVerticalPadding: 10,
              horizontalTitleGap: 10,
              tileColor: Colors.grey[200],
              // shape: Border.all(color: Colors.grey),
              leading: const Icon(Icons.login),
              title: const Text('Login History'),
              onTap: () {
                Navigation.gotoLoginHistoryPage(context);
              },
            ),
            const SizedBox(
              height: 5,
            ),
            ListTile(
              tileColor: Colors.grey[200],
              // shape: Border.all(color: Colors.grey),
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () async {
                await _showMyDialog();
              },
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        // mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // MainLogoBuilder.show('images/MX.png'),
          MainLogoBuilder.show('images/C1.png'),
          // svgProvider(),
          Center(
            child: Text(
              'Welcome  ${widget.name} !',
              style: const TextStyle(fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Are you sure to logout?'),
                Text('Your profile will remove from system.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Approve'),
              onPressed: () async {
                await serverRequest.performLogout();
                Navigation.gotoLoginPage(context, replace: true);
                // Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
