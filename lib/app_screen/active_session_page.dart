import 'dart:async';
import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/network/server_requests.dart'
    as serverRequest;
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ActiveSessionPage extends StatefulWidget {
  Map activeSession = {};
  // ActiveSessionPage({Key? key, required this.activeSession}) : super(key: key)
  ActiveSessionPage({Key? key}) : super(key: key);

  @override
  _ActiveSessionPageState createState() => _ActiveSessionPageState();
}

class _ActiveSessionPageState extends State<ActiveSessionPage> {
  // Dummy Product Data Here
  List sessionList = [];
  bool terminat = false;
  bool loading = false;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    startStreamData();
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()

    // if (mounted)
    _refreshController.loadComplete();
    setState(() {});
  }
  // StreamController<List> loadController = StreamController<List>.broadcast();

  Future<void> startStreamData() async {
    print('start');

    var _response = await serverRequest.getActiveSessionAPI(context);
    if (_response['success'] == true) {
      List activeSessionList = _response['payload']['list'];
      sessionList = activeSessionList;
      loading = true;
      setState(() {});
      // loadController.sink.add(activeSessionList);
      // loadController.close();
    } else {
      loading = false;
      // sessionList = [];
      // setState(() {});
    }
  }

  @override
  void initState() {
    startStreamData();

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Active Session Managment'),
        // backgroundColor: Colors.red,
      ),
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: false,
        // header: const WaterDropHeader(),
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: loading
            ? mainList()
            : const LinearProgressIndicator(
                color: Colors.blue,
              ),
      ),

      // StreamBuilder(
      //   stream: loadController.stream,
      //   builder: (context, AsyncSnapshot snapshot) {
      // loadController.stream.listen((event) {}).onError((error) {
      //   // loadController.stream.listen((event) {}).pause();
      //   Future.delayed(const Duration(seconds: 5), () {
      //     // loadController.stream.listen((event) {}).resume();
      //     startStreamData();
      //   });

      //   // print(error);
      // });

      // loadController.stream.handleError((onError) {
      //   onError:
      //   () => Future.delayed(const Duration(seconds: 5), () {
      //         startStreamData();
      //       });
      // });

      //     if (!snapshot.hasData) {
      //       return mainList();
      //     } else {
      //       switch (snapshot.connectionState) {
      //         case ConnectionState.none:
      //         case ConnectionState.waiting:
      //           return mainList();

      //         case ConnectionState.active:
      //         case ConnectionState.done:
      //           return mainList();

      //         default:
      //           return mainList();
      //       }
      //     }
      //   },
      // ),
      // ),
    );
  }

  Widget mainList() {
    return ListView.builder(
      itemCount: sessionList.length,
      itemBuilder: (BuildContext ctx, index) {
        // Display the list item
        return Dismissible(
            key: UniqueKey(),
            // only allows the user swipe from right to left
            direction: DismissDirection.endToStart,
            // Remove this session from the list
            onDismissed: (_) async {
              var _id = sessionList[index]['session_id'].toString();
              print(sessionList[index]['session_id'].toString());
              await _deletSessionApproveCancelDialog(index);
              if (terminat == true) {
                await serverRequest.terminateActiveSessionAPI(context, _id);
              }

              setState(() {
                // sessionList.removeAt(index);
              });
            },
            child: Card(
              key: UniqueKey(),
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.grey,
                  child: loading
                      ? Text(
                          '${index + 1}',
                          style: const TextStyle(color: Colors.white),
                        )
                      : const Icon(Icons.error),
                ),
                subtitle: loading
                    ? Text('session_id : ${sessionList[index]["session_id"]}')
                    : null,
                title: loading
                    ? Text(
                        "info: ${sessionList[index]["client"]['info'].toString()}")
                    : const Card(
                        // margin: EdgeInsets.all(35),
                        // shape: const Border(left: BorderSide(color: Colors.grey, width: 8)),
                        elevation: 10,
                        child: LinearProgressIndicator(
                          backgroundColor: Colors.grey,
                        ),
                      ),
                trailing: loading
                    ? IconButton(
                        onPressed: () async {
                          var _id = sessionList[index]['session_id'].toString();
                          print(sessionList[index]['session_id'].toString());
                          await _deletSessionApproveCancelDialog(index);
                          if (terminat == true) {
                            await serverRequest.terminateActiveSessionAPI(
                                context, _id);
                          }

                          setState(() {
                            // sessionList.removeAt(index);
                          });
                        },
                        icon: const Icon(Icons.delete),
                      )
                    : null,
              ),
            ));
      },
      // ),
    );
  }

  Future<void> _deletSessionApproveCancelDialog(var index) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Terminate'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                // Text('Alert!'),
                Text('Are you sure to terminate this session?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Approve'),
              onPressed: () {
                sessionList.removeAt(index);
                terminat = true;
                Navigator.of(context).pop(context); //close dialog
              },
            ),
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                terminat = false;
                Navigator.of(context).pop(context); //close dialog
              },
            ),
          ],
        );
      },
    );
  }
}
